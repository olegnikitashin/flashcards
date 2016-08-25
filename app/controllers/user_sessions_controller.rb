class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:user][:email], params[:user][:password])
      flash[:success] = t('user_sess.login_success')
      redirect_to :dashboard
    else
      flash.now[:danger] = t('user_sess.login_failed')
      render action: 'new'
    end
  end

  def destroy
    logout
    flash[:success] = t('user_sess.logout_success')
    redirect_to root_path
  end
end
