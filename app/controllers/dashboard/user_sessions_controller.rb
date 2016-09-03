class Dashboard::UserSessionsController < Dashboard::ApplicationController
  def destroy
    logout
    flash[:success] = t('.logout_success')
    redirect_to root_path
  end
end
