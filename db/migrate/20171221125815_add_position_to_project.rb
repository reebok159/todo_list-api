class AddPositionToProject < ActiveRecord::Migration[5.1]
  def change
    rename_column :tasks, :priority, :position
  end
end
