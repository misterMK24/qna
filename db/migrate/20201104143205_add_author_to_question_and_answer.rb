class AddAuthorToQuestionAndAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :author_id, :bigint
    add_foreign_key :questions, :users, column: :author_id, primary_key: "id"
    add_column :answers, :author_id, :bigint
    add_foreign_key :answers, :users, column: :author_id, primary_key: "id"
  end
end
