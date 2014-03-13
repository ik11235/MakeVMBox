class VmimagesController < ApplicationController
  before_action :set_vmimage, only: [:show, :edit, :update, :destroy]

  # GET /vmimages
  # GET /vmimages.json
  def index
    @vmimages = Vmimage.all
  end

  # GET /vmimages/1
  # GET /vmimages/1.json
  def show
  end

  # GET /vmimages/new
  def new
    @vmimage = Vmimage.new
  end

  # GET /vmimages/1/edit
  def edit
  end

  # POST /vmimages
  # POST /vmimages.json
  def create
    @vmimage = Vmimage.new(vmimage_params)
#    @vmimage.tag_list.add(vmimage_params.tag_list)
    respond_to do |format|
      if @vmimage.save
        format.html { redirect_to @vmimage, notice: 'Vmimage was successfully created.' }
        format.json { render action: 'show', status: :created, location: @vmimage }
      else
        format.html { render action: 'new' }
        format.json { render json: @vmimage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vmimages/1
  # PATCH/PUT /vmimages/1.json
  def update
    respond_to do |format|
      if @vmimage.update(vmimage_params)
        format.html { redirect_to @vmimage, notice: 'Vmimage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vmimage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vmimages/1
  # DELETE /vmimages/1.json
  def destroy
    @vmimage.destroy
    respond_to do |format|
      format.html { redirect_to vmimages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vmimage
      @vmimage = Vmimage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vmimage_params
      params.require(:vmimage).permit(:osname, :osversion,:tag_list)
    end
end
