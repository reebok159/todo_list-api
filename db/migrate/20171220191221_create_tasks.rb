class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.datetime :deadline
      t.integer :priority, null: false
      t.references :project, index: true, foreign_key: true

      t.timestamps
    end
  end
end
