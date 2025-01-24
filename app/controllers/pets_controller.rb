class PetsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pets = Pet.all

    if params[:query].present?
      @pets = @pets.search_by_breed_and_size_and_description_and_pet_name_and_available(params[:query])
    end

    if params[:breed].present? && params[:breed] != "All Breeds"
      @pets = @pets.where(breed: params[:breed])
    end

    if params[:size].present? && params[:size] != "All Sizes"
      @pets = @pets.where(size: params[:size])
    end

    if params[:available].present?
      @pets = @pets.where(available: ActiveModel::Type::Boolean.new.cast(params[:available]))
    end
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
      render :new, status: :unprocessable_entity
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
    @pet.destroy
    redirect_to pets_url, notice: 'Pet was successfully removed.'
  end

  private

  def authorize_owner
    unless current_user.is_owner
      redirect_to pets_path, alert: 'Only pet owners can add pets!'
    end
  end

  def pet_params
    params.require(:pet).permit(:pet_name,
                                :breed,
                                :age,
                                :size,
                                :description,
                                :available,
                                :pet_photo)
  end
end
