class Dashboard::UsersController < Dashboard::ApplicationController
  before_action :find_user

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = t('.success_update', user: @user.email)
      redirect_to :trainer
    else
      flash.now[:danger] = t('.failed_update', user: @user.email)
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t('.success_delete', user: @user.email)
    redirect_to root_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :language)
  end
end
