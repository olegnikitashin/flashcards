class Home::OauthsController < Home::ApplicationController
  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if @user = login_from(provider)
      flash[:success] = t('.success_login', provider: provider.titleize)
      redirect_to :trainer
    else
      begin
        @user = create_from(provider)
        reset_session # protect from session fixation attack
        auto_login(@user)
        flash[:success] = t('.success_login', provider: provider.titleize)
        redirect_to :trainer
      rescue
        flash[:danger] = t('.failed_login', provider: provider.titleize)
        redirect_to root_path
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
