class HomeController < ApplicationController
  skip_before_filter :require_login, only: :welcome

  def welcome
  end

  def index
    @random_card = current_user.cards.random_card
  end

  def check_card
    @card = current_user.cards.find(params[:card][:id])
    @input_text = params[:card][:input_text]

    if @card.words_equal?(@input_text)
      @card.update_date
      flash[:info] = "Correct translation. Well done!"
      redirect_to dashboard_path
    else
      flash[:danger] = "Incorrect translation. Please review the word!"
      redirect_to @card
    end
  end
end
