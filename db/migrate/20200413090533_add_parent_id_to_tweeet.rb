class AddParentIdToTweeet < ActiveRecord::Migration[6.0]
  def change
    add_column :tweeets, :parent_id, :integer
  end
end
