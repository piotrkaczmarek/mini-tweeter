class AddRatingAndRatedByToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :rating, :real
    add_column :microposts, :rated_by, :integer
  end
end
