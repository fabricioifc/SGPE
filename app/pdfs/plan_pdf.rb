class PlanPdf < PdfReport
  include ApplicationHelper

  TABLE_WIDTHS = [70, 470]
  TABLE_HEADERS = [["Ano/semestre", "Disciplina"]]

  TABLE_WIDTHS_2 = 540

  def initialize(plan, user)
    @plano = plan
    super({
      id: plan.id,
      title: 'Plano de Ensino',
      user: user,
      company: {
        name:   Rails.application.secrets.sistema_apelido,
        email:  Rails.application.secrets.admin_email,
        logo:   Rails.root.join("app/assets/images/logo.png")
      },
        # data: {
        #   table_data: table_data,
        #   table_widths: TABLE_WIDTHS
        # }
      },

    )
  end

  def generate options = [header:true, pagination:true, footer:true]
    bounding_box [35, cursor], width: 540 do
      bounding_box [0, cursor], width: 540 do
        repeat :all, :dynamic => true do
          header
          show_pagination
        end

        ano_semestre = @plano.offer_discipline.offer.year.to_s << (
          @plano.offer_discipline.offer.semestre? ? "/#{@plano.offer_discipline.offer.semestre}" : ''
        )

        ultimo_plano_aprovado = get_planos_disciplina_aprovados(@plano.offer_discipline_id).first

        display_event_table(
          table_data(
            [['Curso']],
            [
              "#{@plano.offer_discipline.grid_discipline.grid.course.sigla} - #{@plano.offer_discipline.grid_discipline.grid.course.name}"
            ]
          ),
          [540],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0, columns_bold: [[1,0..0]], columns_background: [1 => [[0, "ffffcc"]]] }
        )

        display_event_table(
          table_data(
            [['Componente curricular', 'Professor', 'Turma']],
            [
              @plano.offer_discipline.grid_discipline.discipline.title,
              @plano.offer_discipline.user.name || @plano.offer_discipline.user.email,
              "#{@plano.offer_discipline.offer.turma.year}.#{@plano.offer_discipline.offer.turma.name}",
            ]
          ),
          [240, 240, 60],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0, columns_bold: [[1,0..0]], columns_background: [1 => [[0, "ffffcc"]]] }
        )

        display_event_table(
          table_data(
            [['Oferta', 'Modalidade', 'Forma', 'Qtd. Horas', 'Qtd. H/A']],
            [
              "#{ano_semestre}",
              @plano.offer_discipline.grid_discipline.grid.course.course_modality.description,
              @plano.offer_discipline.grid_discipline.grid.course.course_format.name,
              @plano.offer_discipline.grid_discipline.decorate.carga_horaria_hora_text,
              @plano.offer_discipline.grid_discipline.decorate.carga_horaria_aula_text
            ]
          ),
          [134, 134, 134, 69, 69],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0 }
        )

        distancia = !@plano.offer_discipline.ead_percentual_maximo.nil? &&
              !@plano.offer_discipline.ead_percentual_maximo.eql?(0) &&
              !@plano.ead_percentual_definido.nil?

        if distancia
          horarios = @plano.decorate.carga_horaria_presencial_distancia

          display_event_table(
            table_data(
              [['Carga horária (Hora)', 'Carga horária (Hora/Aula)']],
              [
                "Presencial: #{horarios[:presencial]} - À distância: #{horarios[:distancia]}",
                "Presencial: #{horarios[:presencial_aula]} - À distância: #{horarios[:distancia_aula]}"
              ]
            ),
            [270, 270],
            { header:true },
            { borders: [:top, :bottom, :left, :right], borders_length: 0 }
          )
        end

        move_down 10
        bounding_box [bleft, cursor + 5], :width  => TABLE_WIDTHS_2 do
          stroke_color "f2f2f2"
          stroke_horizontal_rule
        end

        display_event_table(
          table_data([['Ementa']], [@plano.offer_discipline.grid_discipline.decorate.ementa(true)]),
          [TABLE_WIDTHS_2],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0 }
        )
        display_event_table(
          table_data([['Objetivo Geral']], [@plano.offer_discipline.grid_discipline.decorate.objetivo_geral(true)]),
          [TABLE_WIDTHS_2],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0 }
        )
        display_event_table(
          table_data([['Objetivos Específicos']], [@plano.decorate.obj_espe(true)]),
          [TABLE_WIDTHS_2],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0 }
        )
        display_event_table(
          table_data([['Conteúdo programático']], [@plano.decorate.conteudo_prog(true)]),
          [TABLE_WIDTHS_2],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0 }
        )
        display_event_table(
          table_data([['Práticas profissionais']], [@plano.decorate.prat_prof(true)]),
          [TABLE_WIDTHS_2],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0 }
        )
        display_event_table(
          table_data([['Interdisciplinariedade']], [@plano.decorate.interdisc(true)]),
          [TABLE_WIDTHS_2],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0 }
        )
        display_event_table(
          table_data([['Metodologia Técnica']], [@plano.decorate.met_tec(true)]),
          [TABLE_WIDTHS_2],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0 }
        )
        display_event_table(
          table_data([['Recursos metodológicos']], [@plano.decorate.met_met(true)]),
          [TABLE_WIDTHS_2],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0 }
        )
        display_event_table(
          table_data([['Sistema de avaliação e recuperação']], [@plano.decorate.avaliacao(true)]),
          [TABLE_WIDTHS_2],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0 }
        )
        display_event_table(
          table_data([['Cronograma de atividades']], [@plano.decorate.cronograma(true)]),
          [TABLE_WIDTHS_2],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0 }
        )
        display_event_table(
          table_data([['Bibliografia Básica']], [@plano.offer_discipline.grid_discipline.decorate.bib_geral(true)]),
          [TABLE_WIDTHS_2],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0 }
        )
        display_event_table(
          table_data([['Bibliografia Complementar']], [@plano.offer_discipline.grid_discipline.decorate.bib_espec(true)]),
          [TABLE_WIDTHS_2],
          { header:true },
          { borders: [:top, :bottom, :left, :right], borders_length: 0 }
        )

        move_down 10
        bounding_box [bleft, cursor + 5], :width  => TABLE_WIDTHS_2 do
          stroke_color "f2f2f2"
          stroke_horizontal_rule
        end

        observacoes = nil
        if !ultimo_plano_aprovado.nil?
          if !ultimo_plano_aprovado.versao.eql?(@plano.versao)
            observacoes = "A versão #{ultimo_plano_aprovado.versao.to_f} é a última versão aprovada para este plano de ensino."
          end
        end

        display_event_table(
          table_data(
            [['Informações complementares']],
            [
              "Versão: #{@plano.versao.to_f} - #{@plano.decorate.situacao_texto}"
            ]
          ),
            [TABLE_WIDTHS_2],
            { header:true },
            { borders: [:top, :bottom, :left, :right], borders_length: 0 }
          )
          if !observacoes.nil?
            display_event_table(
              table_data(
                [['Observações']],
                [
                  observacoes
                ]
              ),
              [TABLE_WIDTHS_2],
              { header:true },
              { borders: [:top, :bottom, :left, :right], borders_length: 0 }
            )
          end
        end
      footer
    end
    self
  end

  private

  def table_data table_header, values = []
    table_header +
      [
        values.each do |e|
          e
        end
      ]
  end


end
