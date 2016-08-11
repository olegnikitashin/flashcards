class HomeController < ApplicationController
  before_action :require_login, except: [:index]
  def index
    if current_user
      @random_card = current_user.cards.random_card
    end
  end

  def check_card
    @card = current_user.cards.find(params[:card][:id])
    @input_text = params[:card][:input_text]

    if @card.words_equal?(@input_text)
      @card.update_date
      flash[:info] = "Correct translation. Well done!"
      redirect_to root_path
    else
      flash[:danger] = "Incorrect translation. Please review the word!"
      redirect_to @card
    end
  end
end
