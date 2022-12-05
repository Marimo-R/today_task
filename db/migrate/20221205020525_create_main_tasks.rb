class CreateMainTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :main_tasks do |t|

      t.timestamps
      t.integer :user_id, null: false
      t.integer :category_id
      t.string :main_task, null: false
      t.string :memo
      t.datetime :due_date
      t.integer :status, null: false
      t.boolean :is_today_task, null: false
    end
  end
end
