class DecksController < ApplicationController
  before_action :set_deck, only: [:show, :edit, :update, :destroy, :make_current]

  def index
    @decks = current_user.decks.order(created_at: :desc)
  end

  def show
  end

  def new
    @deck = current_user.decks.new
  end

  def create
    @deck = current_user.decks.new(deck_params)

    if @deck.save
      redirect_to decks_path
      flash[:notice] = "Card deck #{@deck.title} was created!"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @deck.update(deck_params)
      redirect_to decks_path
      flash[:notice] = 'Card deck was updated!'
    else
      render 'edit'
    end
  end

  def destroy
    @deck.destroy
    redirect_to decks_path
    flash[:notice] = 'Card deck was deleted!'
  end

  def make_current
    Deck.where(current: true).update_all(current: false)
    @deck.current = !@deck.current
    @deck.save

    redirect_to @deck
  end

  private

  def set_deck
    @deck = @current_user.decks.find(params[:id])
  end

  def deck_params
    params.require(:deck).permit(:title, :user_id, :current)
  end
end
