class Home::UserSessionsController < Home::ApplicationController

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:user][:email], params[:user][:password])
      flash[:success] = t('.login_success')
      redirect_to :trainer
    else
      flash.now[:danger] = t('.login_failed')
      render action: 'new'
    end
  end
end
