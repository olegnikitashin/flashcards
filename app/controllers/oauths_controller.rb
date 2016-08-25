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
      flash[:success] = t('oauth.success_login', provider: provider.titleize)
      redirect_to :dashboard
    else
      begin
        @user = create_from(provider)
        reset_session # protect from session fixation attack
        auto_login(@user)
        flash[:success] = t('oauth.success_login', provider: provider.titleize)
        redirect_to :dashboard
      rescue
        flash[:danger] = t('oauth.failed_login', provider: provider.titleize)
        redirect_to root_path
      end
    end
  end

  def destroy
    provider = params[:provider]

    authentication = current_user.authentications.find_by_provider(provider)
    if authentication.present?
      authentication.destroy
      flash[:success] = t('oauth.success_unlunk', provider: provider.titleize)
    else
      flash[:danger] = t('oauth.failed_unlink', provider: provider.titleize)
    end

    redirect_to root_path
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
