class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy, :reset_revisions]

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
      flash[:notice] = 'Card was successfully saved!'
      redirect_to @card
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @card.update(card_params)
      flash[:notice] = 'Card was successfully updated!'
      redirect_to @card
    else
      render :edit
    end
  end

  def destroy
    @card.destroy
    flash[:notice] = 'Card was deleted!'
    redirect_to cards_path
  end

  def reset_revisions
    @card.update(revisions: 0)
    redirect_to @card
  end

  private

  def set_card
    @card = current_user.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date, :picture, :deck_id, :revisions)
  end
end
