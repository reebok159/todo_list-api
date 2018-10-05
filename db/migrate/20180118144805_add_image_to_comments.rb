class AddImageToComments < ActiveRecord::Migration[5.1]
  def change
    change_table :comments do |t|
      t.string :image
    end
  end
end
