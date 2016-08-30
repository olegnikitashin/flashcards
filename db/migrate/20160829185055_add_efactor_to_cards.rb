class AddEfactorToCards < ActiveRecord::Migration
  def change
    add_column :cards, :efactor, :float, default: 2.5
    add_column :cards, :repetition, :integer, default: 0
    remove_column :cards, :attempts
    remove_column :cards, :revisions
  end
end
