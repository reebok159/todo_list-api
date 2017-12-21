class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :text

      t.timestamps
    end

    add_reference :comments, :task, foreign_key: true
  end
end
