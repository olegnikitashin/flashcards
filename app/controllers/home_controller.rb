class HomeController < ApplicationController
  skip_before_filter :require_login, only: :welcome

  def welcome
  end

  def index
    @random_card = if current_user && current_user.decks.find_current_deck.nil?
      current_user.cards.random_card
    elsif current_user && !current_user.decks.find_current_deck.nil?
      current_user.decks.find_current_deck.cards.random_card
    else
      nil
    end
  end

  def check_card
    @card = current_user.cards.find(params[:card][:id])
    @input_text = params[:card][:input_text]

    if @card.words_equal?(@input_text)
      @card.increase_count
      flash[:info] = "Correct translation. Well done!"
    else
      @card.decrease_count
      flash[:danger] = "Incorrect translation. Please review the word!"
    end
    redirect_to dashboard_path
  end
end
