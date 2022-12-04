class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|

      t.timestamps
      t.integer :user_id, null: false
      t.string :category, null: false
    end
  end
end