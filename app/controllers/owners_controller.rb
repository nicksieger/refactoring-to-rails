class OwnersController < ApplicationController
  before_filter :load_owner, :only => [:edit, :show, :update, :destroy]

  def index
    name = params[:lastName] || ''
    @owners = Owner.find_by_name(name)
    if @owners.size < 1
      flash[:notice] = "#{params[:lastName]} #{t(:notFound)}"
      render "search"
    elsif @owners.size == 1
      redirect_to owner_path(@owners.first)
    end
  end

  def search
  end

  def new
    @owner = Owner.new
  end

  def edit
  end

  def create
    @owner = Owner.new
    create_or_update("new")
  end

  def show
  end

  def update
    create_or_update("edit")
  end

  def destroy
    if @owner
      session_factory.transaction do |session|
        session.delete(@owner)
      end
      flash[:notice] = "Destroy owner #{@owner.first_name} #{@owner.last_name} successful."
      redirect_to owners_path
    end
  end

  private
  def load_owner
    unless (@owner ||= Owner.load params[:id].to_i)
      flash[:notice] = t(:notFound)
      redirect_to owners_path
    end
  end

  def create_or_update(template)
    @owner.update_attributes params[:owner]
    if @owner.valid?
      @owner.save
      redirect_to owner_path(@owner)
    else
      render template
    end
  end
end
