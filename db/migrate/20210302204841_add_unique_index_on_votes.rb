class AddUniqueIndexOnVotes < ActiveRecord::Migration[6.0]
  def change
    add_index :votes, [:user_id, :votable_id], unique: true
  end
end
