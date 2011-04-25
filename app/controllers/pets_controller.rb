class PetsController < ApplicationController
  before_filter :load_owner
  before_filter :new_pet, :only => [:new, :create]
  before_filter :load_pet, :only => [:show, :edit, :update, :destroy]

  def new
    @types = clinic.pet_types
  end

  def show
  end

  def edit
    @types = clinic.pet_types
  end

  def create
    create_or_update('new')
  end

  def update
    create_or_update('edit')
  end

  def destroy
    @pet.destroy
    redirect_to owner_path(params[:owner_id])
  end

  private
  def load_owner
    unless (@owner ||= Owner.load params[:owner_id].to_i)
      flash[:notice] = t(:notFound)
      redirect_to owners_path
    end
  end

  def load_pet
    @pet = Pet.load(params[:id])
  end

  def new_pet
    @pet = Pet.new.tap {|pet| pet.owner = @owner }
  end

  def create_or_update(template)
    @pet.update_attributes params[:pet]
    if @pet.valid?
      @pet.save
      redirect_to owner_path(@owner)
    else
      render template
    end
  end
end
