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
      flash[:success] = t('.success_create', user: @user.email)
      redirect_to :dashboard
    else
      flash.now[:danger] = t('.failed_create')
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = t('.success_update', user: @user.email)
      redirect_to :dashboard
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
