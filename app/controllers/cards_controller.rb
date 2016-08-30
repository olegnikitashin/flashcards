class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy, :reset_repetitions, :reset_efactor]

  def index
    @cards = current_user.cards.order(created_at: :desc)
  end

  def show
  end

  def new
    @card = current_user.cards.new
  end

  def create
    @card = current_user.cards.new(card_params)

    if @card.save
      flash[:success] =  t('.success_create', card: @card.original_text)
      redirect_to @card
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @card.update(card_params)
      flash[:success] = t('.success_update', card: @card.original_text)
      redirect_to @card
    else
      render :edit
    end
  end

  def destroy
    @card.destroy
    flash[:success] = t('.success_delete', card: @card.original_text)
    redirect_to cards_path
  end

  def reset_repetitions
    @card.reset_repetitions
    redirect_to @card
  end

  def reset_efactor
    @card.reset_efactor
    redirect_to @card
  end

  private

  def set_card
    @card = current_user.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date, :picture, :deck_id, :repetition, :efactor)
  end
end
