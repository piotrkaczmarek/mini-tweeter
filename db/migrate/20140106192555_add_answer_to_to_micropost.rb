class AddAnswerToToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :answer_to, :integer
  end
end
