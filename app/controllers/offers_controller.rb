class OffersController < ApplicationController
  before_action :set_offer, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :load_cursos

  # GET /offers
  # GET /offers.json
  def index
    # @offers = Offer.all
    respond_to do |format|
      format.html
      format.json { render json: OfferDatatable.new(view_context) }
    end
  end

  # GET /offers/1
  # GET /offers/1.json
  def show
  end

  # GET /offers/new
  def new
    # @grades = []
    @grades = Grid.includes(:course).
      joins(:grid_disciplines => :discipline).
      pluck('id', 'grid_disciplines.year', 'grid_disciplines.semestre', 'courses.name', 'year').uniq
    # semestres = Grid.includes(:course).
    #   joins(:grid_disciplines => :discipline).
    #   where('grid_disciplines.semestre is not null').
    #   pluck('id', 'grid_disciplines.semestre', 'courses.name', 'year').uniq

    # @grades << semestres unless semestres.empty?

    @offer = Offer.new
  end

  # GET /offers/1/edit
  def edit
  end

  # POST /offers
  # POST /offers.json
  def create
    @offer = Offer.new(offer_params)

    respond_to do |format|
      if @offer.save
        format.html { redirect_to @offer, notice: 'Offer was successfully created.' }
        format.json { render :show, status: :created, location: @offer }
      else
        format.html { render :new }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offers/1
  # PATCH/PUT /offers/1.json
  def update
    respond_to do |format|
      if @offer.update(offer_params)
        format.html { redirect_to @offer, notice: 'Offer was successfully updated.' }
        format.json { render :show, status: :ok, location: @offer }
      else
        format.html { render :edit }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy
    @offer.destroy
    respond_to do |format|
      format.html { redirect_to offers_url, notice: 'Offer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def load_grid

    if !params[:grid].blank?
      grid_id = params[:grid].split('_')[0]
      ano = params[:grid].split('_')[1]
      semestre = params[:grid].split('_')[2]

      @grid = []

      if !ano.nil?
        @grid = Grid.joins(:grid_disciplines).where('grids.id = ?', grid_id).where(:grid_disciplines => {:year => ano.to_i})
      elsif !semestre.nil?
        @grid = Grid.joins(:grid_disciplines => :discipline).
          where(id: grid_id).
          where('grid_disciplines.semestre = ?', semestre).uniq
      end

      respond_to do |format|
        format.js
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Offer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_params
      params.require(:offer).permit(:year, :semestre, :type, :course_id)
    end

    def load_cursos
      @cursos = Course.where(active:true)
    end
end
