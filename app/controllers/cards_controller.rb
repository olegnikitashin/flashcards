class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]

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
      redirect_to @card
      flash[:notice] = 'Card was successfully saved!'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @card.update(card_params)
      redirect_to @card
      flash[:notice] = 'Card was successfully updated!'
    else
      render :edit
    end
  end

  def destroy
    @card.destroy
    redirect_to cards_path
    flash[:notice] = 'Card was deleted!'
  end

  private

  def set_card
    @card = current_user.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date, :picture, :deck_id)
  end
end
