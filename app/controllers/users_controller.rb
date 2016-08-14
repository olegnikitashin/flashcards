class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :find_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to :dashboard, notice: "Пользователь #{@user.email} успешно создан!"
    else
      flash.now[:alert] = 'Пользователь не был создан!'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to :dashboard, notice: "Данные пользователя #{@user.email} успешно обновлены!"
    else
      flash.now[:alert] = "Данные пользователя #{@user.email} не были успешно обновлены!"
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path, notice: "Пользователь был удален!"
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
