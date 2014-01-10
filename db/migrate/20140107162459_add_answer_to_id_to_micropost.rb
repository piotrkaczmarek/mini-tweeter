class AddAnswerToIdToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :answer_to_id, :integer
  end
end
