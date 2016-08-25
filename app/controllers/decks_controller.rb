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
      flash[:success] = t('.success_create', deck: @deck.title)
      redirect_to decks_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @deck.update(deck_params)
      flash[:success] = t('.success_update', deck: @deck.title)
      redirect_to decks_path
    else
      render 'edit'
    end
  end

  def destroy
    @deck.destroy
    flash[:success] = t('.success_delete', deck: @deck.title)
    redirect_to decks_path
  end

  def make_current
    @deck.make_current
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
