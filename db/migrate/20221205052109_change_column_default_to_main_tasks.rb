class ChangeColumnDefaultToMainTasks < ActiveRecord::Migration[6.1]
  def change
    change_column_default :main_tasks, :status, from: nil, to: "0"
  end
end
