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

    (5 - @pet.pet_photos.size).times { @pet.pet_photos.build }
    
    @pet.location = current_user.location if current_user.location.present?
  end 

  def create
    @pet = Pet.new(pet_params.except(:pet_photos))  # Don't include pet_photos in mass assignment
    @pet.user = current_user
  
    # Handle image uploads (in order)
    if pet_params[:pet_photos].present?
      pet_params[:pet_photos].reject(&:blank?).each_with_index do |image_file, idx|
        @pet.pet_photos.build(image: image_file, position: idx)
      end
    end
  
    if @pet.save
      redirect_to @pet, notice: "Pet was successfully added."
    else
      Rails.logger.debug @pet.errors.full_messages.inspect
      render :new, status: :unprocessable_entity, notice: "Pet could not be added. Please try again."
    end
  end
 
  
  def edit
    @pet = Pet.find(params[:id])
  end

  def update
    @pet = Pet.find(params[:id])
  
    # Step 1: Update all existing images and their positions/deletions
    if @pet.update(pet_params.except(:pet_photos))
      # Step 2: Add new uploads at their intended positions
      if params[:pet][:pet_photos].present?
        new_positions = params[:pet][:new_photo_positions]&.map(&:to_i) || []
        files = params[:pet][:pet_photos].reject(&:blank?)
        files.each_with_index do |file, idx|
          # This is the intended position as chosen in the UI (profile = 0, etc)
          position = new_positions[idx] || (@pet.pet_photos.maximum(:position) || -1) + 1
          @pet.pet_photos.build(image: file, position: position)
        end
        @pet.save # Save new photos
      end
  
      # After saving, ensure all photos (existing and new) are re-ordered by position
      @pet.pet_photos.order(:position).each_with_index do |photo, idx|
        photo.update_column(:position, idx)
      end
  
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
                                pet_photos: [],
                                pet_photos_attributes: [:id, :image, :position, :_destroy]
    )
  end
end
