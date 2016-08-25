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
      flash[:success] = t('home.correct')
    elsif @card.levenshtein_check(@input_text) <= 2
      @card.increase_count
      flash[:warning] = t('home.misspelled', input: @input_text.capitalize, original: @card.original_text.capitalize)
    else
      @card.decrease_count
      flash[:danger] = t('home.incorrect')
    end
    redirect_to dashboard_path
  end
end
