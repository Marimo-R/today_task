class ChangeDataDueDateToMainTasks < ActiveRecord::Migration[6.1]
  def change
    change_column :main_tasks, :due_date, :date
  end
end