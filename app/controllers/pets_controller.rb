class PetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pets = Pet.all
  
    if params[:query].present?
      @pets = @pets.search_by_breed_and_size_and_description_and_pet_name_and_available(params[:query])
    end
  
    if params[:breed].present? && params[:breed] != "Any Type"
      @pets = @pets.where(breed: params[:breed])
    end
  
    if params[:size].present? && params[:size] != "Any Size"
      @pets = @pets.where(size: params[:size])
    end
    
    if params[:location].present?
      distance = params[:distance].presence || 50
      @pets = Pet.near(params[:location], distance)
    end

    if params[:location].present?
      coords = Geocoder.search(params[:location]).first&.coordinates
      @user_location = coords if coords
    end
    
    @user_location ||= [53.8008, -1.5491] # fallback
        
    if params[:available_from].present? && params[:available_until].present?
      from = Date.parse(params[:available_from])
      to   = Date.parse(params[:available_until])
      @pets = @pets.select do |pet|
        pet.available_from && (
          (
            pet.available_until && from <= pet.available_until && to >= pet.available_from
          ) ||
          (
            pet.available_until.nil? && to >= pet.available_from
          )
        )
      end
    elsif params[:available_from].present?
      from = Date.parse(params[:available_from])
      @pets = @pets.select { |pet| pet.available_from && from <= (pet.available_until || Date.today + 10.years) }
    
    elsif params[:available_until].present?
      to = Date.parse(params[:available_until])
      @pets = @pets.select { |pet| pet.available_from && pet.available_from <= to }
    end

    @pets = @pets.select(&:available_now?)
  end
  
  def show
    @pet = Pet.find(params[:id])
  end

  def new
    @pet = Pet.new
  end

  def create
    @pet = Pet.new(pet_params)
    @pet.user = current_user
    if @pet.save
      redirect_to @pet, notice: 'Pet was successfully added.'
    else
      Rails.logger.debug @pet.errors.full_messages.inspect
      render :new, status: :unprocessable_entity,
      notice: 'Pet could not be added. Please try again.'
    end
  end

  def edit
    @pet = Pet.find(params[:id])
  end

  def update
    @pet = Pet.find(params[:id])
    if @pet.update(pet_params)
      redirect_to @pet, notice: 'Pet was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pet = Pet.find(params[:id])

    # Allow only the owner to delete the pet
    if @pet.user == current_user
      @pet.destroy
      flash[:notice] = 'Pet was successfully removed.'
    else
      flash[:alert] = 'You are not authorized to delete this pet.'
    end

    redirect_to user_path(current_user)
  end

  private

  def authorize_owner
    unless current_user.is_owner
      redirect_to pets_path, alert: 'Only pet owners can add pets!'
    end
  end

  def pet_params
    params.require(:pet).permit(:pet_name,
                                :animal_type,
                                :breed,
                                :age,
                                :size,
                                :description,
                                :location,
                                :available_from,
                                :available_until,
                                :highlights,
                                :pet_photo,
                                pet_photos: [])
  end
  end
