class OauthsController < ApplicationController
  skip_before_filter :require_login
  before_filter :require_login, only: :destroy

  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    if @user = login_from(provider)
      redirect_to root_path
      flash[:notice] = "Logged in from #{provider.titleize}!"
    else
      begin
        @user = create_from(provider)
        reset_session # protect from session fixation attack
        auto_login(@user)
        redirect_to root_path
        flash[:notice] = "Logged in from #{provider.titleize}!"
      rescue
        redirect_to root_path
        flash[:aler] = "Failed to login from #{provider.titleize}!"
      end
    end
  end

  def destroy
    provider = params[:provider]

    authentication = current_user.authentications.find_by_provider(provider)
    if authentication.present?
      authentication.destroy
      flash[:notice] = "You have successfully unlinked your #{provider.titleize} account."
    else
      flash[:alert] = "You do not currently have a linked #{provider.titleize} account."
    end

    redirect_to root_path
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
