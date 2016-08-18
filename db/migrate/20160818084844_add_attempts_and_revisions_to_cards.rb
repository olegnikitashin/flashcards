class AddAttemptsAndRevisionsToCards < ActiveRecord::Migration
  def change
    add_column :cards, :attempts, :integer, default: 3
    add_column :cards, :revisions, :integer, default: 0
  end
end
