class RemoveAnswerToFromMicropost < ActiveRecord::Migration
  def change
    remove_column :microposts, :answer_to
  end
end
