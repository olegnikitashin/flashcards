class Dashboard::OauthsController < Dashboard::ApplicationController
  def destroy
    provider = params[:provider]

    authentication = current_user.authentications.find_by_provider(provider)
    if authentication.present?
      authentication.destroy
      flash[:success] = t('.success_unlunk', provider: provider.titleize)
    else
      flash[:danger] = t('.failed_unlink', provider: provider.titleize)
    end
    redirect_to root_path
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end
end
