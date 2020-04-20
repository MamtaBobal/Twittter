class AddIndexToLike < ActiveRecord::Migration[6.0]
  def change
  	add_index :likes, [:user_id, :tweeet_id], unique: true 
  end
end
