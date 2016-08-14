class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:user][:email], params[:user][:password])
      redirect_to :dashboard
      flash[:notice] = 'Login successful!'
    else
      flash.now[:alert] = 'Login failed!'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(root_path, notice: 'Logged out!')
  end
end
