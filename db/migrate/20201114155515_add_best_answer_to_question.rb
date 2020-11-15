class AddBestAnswerToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :best_answer_id, :bigint
    add_foreign_key :questions, :answers, column: :best_answer_id, validate: false, on_delete: :nullify
  end
end
