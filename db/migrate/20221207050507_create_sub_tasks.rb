class CreateSubTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :sub_tasks do |t|

      t.timestamps
      t.integer :main_task_id, null: false
      t.string :sub_task, null: false
      t.string :memo
      t.datetime :due_date
      t.integer :status, null: false, default: 0
      t.boolean :is_today_task, null: false
    end
  end
end