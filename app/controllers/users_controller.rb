class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :show

  def index
    @users = User.all
    respond_to do |format|
      format.html
      # format.json { render json: TestDatatable.new(view_context) }
      format.pdf do
        35.times do
          @users += User.all
        end
        pdf = UsersPdf.new(@users)
        send_data pdf.render,
            filename: "usuários_#{@users.count}",
            type: 'application/pdf',
            disposition: 'inline'
      end
    end
  end

  def show
    @user = User.find(params[:id])

    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => "Access denied."
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to root_path, :alert => "Access denied."
    end
  end

  def secure_params
    params.require(:user).permit(:perfils, :avatar, :avatar_cache, :perfil_ids => [])
  end

  def user_params
    params.require(:user).permit(:perfils, :avatar, :avatar_cache, :perfil_ids => [])
  end

end
