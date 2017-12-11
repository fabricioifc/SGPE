class GridsController < ApplicationController
  before_action :set_grid, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource
  responders :flash

  add_breadcrumb (I18n.t "helpers.links.pages.#{controller_name}", default: controller_name), :grids_path

  before_action :load_cursos_ativos
  before_action :load_disciplinas

  def importar

    file = params[:file]
    unless file.nil?
      ActiveRecord::Base.transaction do

        spreadsheet = Roo::Spreadsheet.open(file.path)
        header = spreadsheet.row(1)
        course = Course.find(params[:course_id])

        @grid = Grid.find_or_initialize_by(year: params[:year], course: course) do |grid|
          grid.user = current_user
          active    = true
        end
        @grid.carga_horaria = 0 if @grid.carga_horaria.nil?

        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]

          if row['discipline_title'].blank? || row['discipline_title'].nil?
            break
          else

            # Criar a disciplina
            discipline = Discipline.find_or_initialize_by(
              title: row['discipline_title'],
              sigla: row['discipline_title'].upcase[0, 3],
              active:true,
              user: current_user
            )

            ano = row['ano_semestre'].downcase.include?('ano') ? row['ano_semestre'].to_i : nil unless row['ano_semestre'].nil?
            semestre = row['ano_semestre'].downcase.include?('semestre') ? row['ano_semestre'].to_i : nil unless row['ano_semestre'].nil?

            # Disciplina da grade
            grid_discipline = GridDiscipline.find_or_initialize_by(
              discipline: discipline,
              year: ano,
              semestre: semestre,
              carga_horaria: row['grid_discipline_carga_horaria'].to_i || 0,
              ementa: row['ementa'],
              objetivo_geral: row['objetivo_geral'],
              bib_geral: row['bib_geral'],
              bib_espec: row['bib_espec'],
            )
            grid_discipline.grid = @grid

            if grid_discipline.valid?
              @grid.carga_horaria += row['grid_discipline_carga_horaria'].to_i
            else
              grid_discipline.errors.add(:base, "Erro na linha #{i}")
            end

            @grid.grid_disciplines << grid_discipline
          end
        end

        if @grid.valid?
          if @grid.new_record?
            respond_to do |format|
              flash[:notice] = 'Arquivo de grades importado com sucesso. Verifique as disciplinas.'
              format.html { render :new }
            end
            # redirect_to new_grid_path(grid: @grid), notice: 'Arquivo de grades importado com sucesso. Verifique as disciplinas.'
          else
            redirect_to edit_grid_path(@grid), notice: 'Arquivo de grades importado com sucesso. Verifique as disciplinas.'
          end
          # if @grid.save!
            # flash[:notice] = 'Arquivo de grades importado com sucesso.'
          # else
          #   flash[:alert] = 'Erro ao importar a grade e suas disciplinas.'
          # end
        else
          respond_to do |format|
            flash[:alert] = 'Existem inconsistências no arquivo que impedem a sua importação.'
            format.html { render :importar }
          end
        end
        # redirect_to import_grids_path, notice: 'Arquivo de grades importado com sucesso.'
      end
    end


                # course_format = CourseFormat.find_or_create_by(name: row['course_course_format'])
                # course = Course.find_or_create_by(name: row['course_course_name'], course_format: course_format) do |c|
                #   c.sigla           = row['course_course_name'][0, 5]
                #   c.active          = true
                #   c.user            = current_user
                #   c.course_modality = CourseModality.first
                # end

    # file = params[:file]
    # unless file.nil?
    #   respond_to do |format|
    #
    #     @grids = []
    #     spreadsheet = Roo::Spreadsheet.open(file.path)
    #     header = spreadsheet.row(1)
    #     (2..spreadsheet.last_row).each do |i|
    #       row = Hash[[header, spreadsheet.row(i)].transpose]
    #       @grid = Grid.last
    #       @grid.year = nil
    #       # product = find_by(id: row["id"]) || new
    #       # product.attributes = row.to_hash
    #       # product.save!
    #       if @grid.valid?
    #
    #       else
    #         @grid.errors.add(:base, "Erro na linha #{i}")
    #       end
    #       @grids << @grid
    #     end
    #     flash[:notice] = 'Arquivo de grades importado com sucesso.'
    #     format.html { render :importar }
    #     # redirect_to import_grids_path, notice: 'Arquivo de grades importado com sucesso.'
    #   end
    # end
  end

  # GET /grids
  # GET /grids.json
  def index
    # @grids = Grid.all
    respond_to do |format|
      format.html
      format.json { render json: GridDatatable.new(view_context) }
    end
  end

  # GET /grids/1
  # GET /grids/1.json
  def show
    respond_to do |format|
      format.html
      format.json
      format.pdf {
        pdf = GridPdf.new(@grid, current_user).generate
        send_data pdf.render,
          filename: "#{@grid.created_at.strftime("%Y%m%d")}_grade#{@grid.id}.pdf",
          type: "application/pdf",
          disposition: :inline
      }
      # format.pdf do
      #   pdf = GridPdf.new(@grid)
      #   send_data pdf.render,
      #       filename: "grid_#{@grid.id}",
      #       type: 'application/pdf',
      #       disposition: 'inline'
      # end
    end
  end

  # GET /grids/new
  def new
    binding.pry
    if @grid.nil?
      @grid = Grid.new
      @grid.grid_disciplines.build
    end
  end

  # GET /grids/1/edit
  def edit
  end

  # POST /grids
  # POST /grids.json
  def create
    @grid = Grid.new(grid_params)
    @grid.user = current_user

    respond_to do |format|
      if @grid.save
        format.html { redirect_to @grid, notice: t('flash.actions.create.notice', resource_name: controller_name.classify.constantize.model_name.human) }
        format.json { render :show, status: :created, location: @grid }
      else
        format.html { render :new }
        format.json { render json: @grid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grids/1
  # PATCH/PUT /grids/1.json
  def update
    respond_to do |format|
      # @grid[:enabled] = false

      if @grid.update(grid_params)
        # @grid = @grid.amoeba_dup
        # @grid.user = current_user
        # @grid.enabled = true

        # if @grid.save
        #
        #   format.html { redirect_to @grid, notice: t('flash.actions.update.notice', resource_name: controller_name.classify.constantize.model_name.human) }
        #   format.json { render :show, status: :ok, location: @grid }
        # else
          format.html { redirect_to @grid, notice: t('flash.actions.update.notice', resource_name: controller_name.classify.constantize.model_name.human) }
          format.json { render :show, status: :ok, location: @grid }
      # end
      else
        format.html { render :edit }
        format.json { render json: @grid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grids/1
  # DELETE /grids/1.json
  # def destroy
  #   @grid.destroy
  #   respond_to do |format|
  #     format.html { redirect_to grids_url, notice: 'Grid was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grid
      @grid = Grid.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grid_params
      params.require(:grid).permit(:year, :active, :enabled, :course_id, :user_id, :carga_horaria,
        grid_disciplines_attributes: [:id, :year, :semestre, :carga_horaria, :ementa, :objetivo_geral, :bib_geral, :bib_espec, :discipline_id, :_destroy]
      )
    end

    def load_cursos_ativos
      @cursos = Course.where(active:true)
    end

    def load_disciplinas
      @disciplinas = Discipline.all
    end
end
