class AddCompletedColumnToTask < ActiveRecord::Migration[5.1]
  def change
    change_table :tasks do |t|
      t.boolean :completed, null: false, default: false
    end
  end
end
