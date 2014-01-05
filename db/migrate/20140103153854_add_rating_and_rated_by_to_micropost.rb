class AddRatingAndRatedByToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :rating, :double
    add_column :microposts, :rated_by, :integer
  end
end
