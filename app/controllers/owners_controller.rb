class OwnersController < ApplicationController
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

  def show
    @owner = Owner.load(params[:id])
  end
end
