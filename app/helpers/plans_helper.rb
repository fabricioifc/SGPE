module PlansHelper

  def nenhum_plano_em_analise? offer_discipline_id
    Plan.where(offer_discipline_id: offer_discipline_id, active:true).
      where(analise:true).where(aprovado:false, reprovado:false).empty? unless offer_discipline_id.nil? || offer_discipline_id.blank?
  end

  def plano_sendo_editado? offer_discipline_id
    !Plan.where(offer_discipline_id: offer_discipline_id, active:true).
      where(analise:false).where(aprovado:false, reprovado:false).empty? unless offer_discipline_id.nil? || offer_discipline_id.blank?
  end

  def planos_por_disciplina offer_discipline_id
    Plan.joins(offer_discipline: {offer: { grid: :course }}).
      where('plans.active is true').
      where('offer_disciplines.id = ?', offer_discipline_id).
      where('offer_disciplines.user_id = ?', current_user.id) if user_signed_in? && !offer_discipline_id.nil?
  end

  def ultimo_plano_aprovado_por_disciplina offer_discipline_id
    Plan.joins(offer_discipline: {offer: { grid: :course }}).
      where('plans.active is true').
      where(aprovado:true).
      where('plans.user_id is not null').
      where('offer_disciplines.user_id is not null').
      where('offer_disciplines.id = ?', offer_discipline_id).
      order(versao: :desc).first if !offer_discipline_id.nil?
  end

  def ultimo_plano_por_disciplina offer_discipline_id
    Plan.joins(offer_discipline: {offer: { grid: :course }}).
      where('plans.active is true').
      where('plans.user_id is not null').
      where('offer_disciplines.user_id is not null').
      where('offer_disciplines.id = ?', offer_discipline_id).
      order(versao: :desc).first if !offer_discipline_id.nil?
  end

  # def aprovados_por_disciplina planos
  #   planos.where(aprovado:true).count
  # end
  #
  # def reprovados_por_disciplina planos
  #   planos.where(reprovado:true).count
  # end
  #
  # def analise_por_disciplina planos
  #   planos.where(analise:true, aprovado:false, reprovado:false).count
  # end
  #
  # def editando_por_disciplina planos
  #   planos.where(analise:false, aprovado:false, reprovado:false).count
  # end

  def ultimo_status_planos analise, aprovado, reprovado, professor = nil
    lista = []
    if !professor.nil?
      ultimos_planos = Plan.select('offer_discipline_id, MAX(versao) AS versao').joins(:offer_discipline).
        group(:offer_discipline_id).where(active:true).where('offer_disciplines.user_id = ?', professor.id)
    else
      ultimos_planos = Plan.select('offer_discipline_id, MAX(versao) AS versao').
        group(:offer_discipline_id).where(active:true)
    end

    ultimos_planos.each do |plano|
      plano = Plan.find_by(offer_discipline_id: plano.offer_discipline_id, versao: plano.versao)
      lista << plano if plano.analise.eql?(analise) && plano.aprovado.eql?(aprovado) && plano.reprovado.eql?(reprovado)
    end
    lista
  end

  # Todos os planos aprovados
  def planos_aprovados professor = nil
    if user_signed_in?
      ultimo_status_planos(true, true, false, professor)
    end
  end

  # Todos os planos reprovados
  def planos_reprovados professor = nil
    if user_signed_in?
      ultimo_status_planos(true, false, true, professor)
      # if professor.nil?
        # Plan.where('plans.active is true').where(analise:true, aprovado:false, reprovado:true)
      # else
        # Plan.where('plans.active is true and plans.user_id = ?', professor.id).where(analise:true, aprovado:false, reprovado:true)
      # end
    end
  end

  # Todos os planos em análise
  def planos_analisando professor = nil
    if user_signed_in?
      ultimo_status_planos(true, false, false, professor)
      # if professor.nil?
      #   Plan.where('plans.active is true').where(analise:true, aprovado:false, reprovado:false)
      # else
      #   Plan.where('plans.active is true and plans.user_id = ?', professor.id).where(analise:true, aprovado:false, reprovado:false)
      # end
    end
  end

  # Todos os planos sendo editado
  def planos_editando professor = nil
    if user_signed_in?
      ultimo_status_planos(false, false, false, professor)
    end
  end

  # Todos os planos
  def planos_total professor = nil
    if user_signed_in?
      lista = []

      if !professor.nil?
        ultimos_planos = Plan.select('offer_discipline_id, MAX(versao) AS versao').
        group(:offer_discipline_id).where(active:true, user: professor)
      else
        ultimos_planos = Plan.select('offer_discipline_id, MAX(versao) AS versao').
        group(:offer_discipline_id).where(active:true)
      end

      ultimos_planos.each do |plano|
        lista << Plan.find_by(offer_discipline_id: plano.offer_discipline_id, versao: plano.versao)
      end

      lista
    end
  end

  # Utilizado para passar parâmetros ao enviar por e-mail
  # Ex: PlanoEnsinoMailer.enviar_email_aviso_nupe(get_options_email).deliver_later!
  # def get_options_email
  #   options = {
  #     id: @plan.id,
  #     offer_id: @plan.offer_discipline.offer_id,
  #     offer_discipline_id: @plan.offer_discipline_id,
  #     curso: "#{@plan.offer_discipline.grid_discipline.grid.course.sigla} - #{@plan.offer_discipline.grid_discipline.grid.course.decorate.name}",
  #     disciplina: @plan.offer_discipline.grid_discipline.discipline.decorate.title,
  #     turma: @plan.offer_discipline.offer.turma,
  #     professor: @plan.user.name,
  #     versao: @plan.decorate.versao,
  #     dtcreated: @plan.created_at.strftime('%d/%m/%Y')
  #   }
  # end

end
