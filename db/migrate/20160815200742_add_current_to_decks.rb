class AddCurrentToDecks < ActiveRecord::Migration
  def change
    add_column :decks, :current, :boolean
  end
end
