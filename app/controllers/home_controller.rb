class HomeController < ApplicationController
  skip_before_filter :require_login, only: :welcome

  def welcome
  end

  def index
    @random_card = if current_user
      if current_user.decks.find_current_deck.nil?
        current_user.cards.random_card
      else
        current_user.decks.find_current_deck.cards.random_card
      end
    end
  end

  def check_card
    @card = current_user.cards.find(params[:card][:id])
    @input_text = params[:card][:input_text]
    if @card.levenshtein_check(@input_text) == 0
      @card.increase_count
      flash[:success] = "Correct translation. Well done!"
    elsif @card.levenshtein_check(@input_text) <= 2
      @card.increase_count
      flash[:warning] = "You were almost right! You entered: #{@input_text.capitalize}, but the correct word is #{@card.original_text.capitalize}!"
    else
      @card.decrease_count
      flash[:danger] = "Incorrect translation. Please review the word!"
    end
    redirect_to dashboard_path
  end
end
