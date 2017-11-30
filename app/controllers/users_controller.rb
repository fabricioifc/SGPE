class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :show

  responders :flash

  def index
    respond_to do |format|
      format.html
      format.json { render json: UserDatatable.new(view_context, current_user, update_perfils_users_path) }
    end
    # @users = User.all
    # respond_to do |format|
    #   format.html
    #   # format.json { render json: TestDatatable.new(view_context) }
    #   format.pdf do
    #     35.times do
    #       @users += User.all
    #     end
    #     pdf = UsersPdf.new(@users)
    #     send_data pdf.render,
    #         filename: "usuários_#{@users.count}",
    #         type: 'application/pdf',
    #         disposition: 'inline'
    #   end
    # end
  end

  def update_perfils
  end

  def show
    @user = User.find(params[:id])

    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => "Acesso negado. Você não tem permissão para acessar este recurso."
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      if current_user.try(:admin?)
        redirect_to user_path(@user), notice: t('flash.actions.update.notice', resource_name: controller_name.classify.constantize.model_name.human)
      else
        redirect_to users_path, notice: t('flash.actions.update.notice', resource_name: controller_name.classify.constantize.model_name.human)
      end
    else
      redirect_to users_path, :alert => "Não foi possível atualizar o usuário."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, notice: t('flash.actions.create.notice', resource_name: controller_name.classify.constantize.model_name.human)
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to root_path, :alert => "Acesso negado. Você não tem permissão para acessar este recurso."
    else
      add_breadcrumb (I18n.t "helpers.links.pages.#{controller_name}", default: controller_name), :users_path
    end
  end

  def secure_params
    params.require(:user).permit(:perfils, :avatar, :avatar_cache, :perfil_ids => [])
  end

  def user_params
    params.require(:user).permit(:perfils, :avatar, :avatar_cache, :perfil_ids => [])
  end

end
