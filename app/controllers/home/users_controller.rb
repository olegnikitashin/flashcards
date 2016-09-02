class Home::UsersController < Home::ApplicationController
  before_action :find_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      flash[:success] = t('.success_create', user: @user.email)
      redirect_to :trainer
    else
      flash.now[:danger] = t('.failed_create')
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :language)
  end
end
