class HomeController < ApplicationController
  def index
    @random_card = Card.random_card
  end

  def check_card
    @card = Card.find(params[:id])
    @input_text = params[:input_text]

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
