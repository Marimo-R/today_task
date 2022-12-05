class MainTasksController < ApplicationController
  def index
    @user = User.find(params[:user_id])
  end

  def show
  end

  def new
    @main_task = MainTask.new
    @categories = Category.where(user_id: params[:user_id])
  end

  def create
    @main_task = MainTask.new(params_main_task)
    @main_task.user_id = current_user.id
    @main_task.save
    redirect_to user_main_tasks_path(current_user.id)
  end

  def edit
  end

  def update
  end

  def complete
  end

  def today_task_flag_update
  end

  def task_status_update
  end

  private
  def params_main_task
    params.require(:main_task).permit(:category_id, :main_task, :memo, :due_date, :is_today_task, :user_id, :status)
  end
end
