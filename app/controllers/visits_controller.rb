class VisitsController < ApplicationController
  before_filter :load_pet
  before_filter :new_visit, :only => [:new, :create]
  before_filter :load_visit, :only => [:show, :edit, :update]

  def index
    @visits = @pet.visits
    respond_to do |format|
      format.atom
    end
  end

  def new
  end

  def edit
  end

  def create
    create_or_update('new')
  end

  def update
    create_or_update('edit')
  end

  private
  def load_pet
    @pet = Pet.load(params[:pet_id])
  end

  def new_visit
    @visit = Visit.new.tap {|v| v.pet = @pet }
  end

  def load_visit
    unless (@visit = @pet.visits.detect {|v| v.id == params[:id].to_i})
      flash[:notice] = t(:notFound)
      redirect_to owner_path(@pet.owner)
    end
  end

  def create_or_update(template)
    @visit.update_attributes params[:visit]
    if @visit.valid?
      @visit.save
      redirect_to owner_path(@pet.owner)
    else
      render template
    end
  end
end
