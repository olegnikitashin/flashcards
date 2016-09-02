class Home::WelcomeController < Home::ApplicationController
  def welcome
    if logged_in?
      redirect_to trainer_path
    end
  end
end
