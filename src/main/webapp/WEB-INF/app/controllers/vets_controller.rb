class VetsController < ApplicationController
  # GET /vets
  # GET /vets.xml
  def index
    @vets = Vet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vets }
    end
  end

  # GET /vets/1
  # GET /vets/1.xml
  def show
    @vet = Vet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vet }
    end
  end

  # GET /vets/new
  # GET /vets/new.xml
  def new
    @vet = Vet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vet }
    end
  end

  # GET /vets/1/edit
  def edit
    @vet = Vet.find(params[:id])
  end

  # POST /vets
  # POST /vets.xml
  def create
    @vet = Vet.new(params[:vet])

    respond_to do |format|
      if @vet.save
        flash[:notice] = 'Vet was successfully created.'
        format.html { redirect_to(@vet) }
        format.xml  { render :xml => @vet, :status => :created, :location => @vet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vets/1
  # PUT /vets/1.xml
  def update
    @vet = Vet.find(params[:id])

    respond_to do |format|
      if @vet.update_attributes(params[:vet])
        flash[:notice] = 'Vet was successfully updated.'
        format.html { redirect_to(@vet) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vets/1
  # DELETE /vets/1.xml
  def destroy
    @vet = Vet.find(params[:id])
    @vet.destroy

    respond_to do |format|
      format.html { redirect_to(vets_url) }
      format.xml  { head :ok }
    end
  end
end
