class SubTasksController < ApplicationController
  def new
    @sub_task = SubTask.new
    @main_tasks = MainTask.where(user_id: current_user.id)
  end

  def create
    @sub_task = SubTask.new(params_sub_task)
    @sub_task.save
    @main_task = @sub_task.main_task
    @main_task.update(status: 0)
    redirect_to user_main_tasks_path(current_user.id)
  end

  def show
    @sub_task = SubTask.find(params[:id])
  end

  def edit
    @sub_task = SubTask.find(params[:id])
    @main_tasks = MainTask.where(user_id: params[current_user.id])
  end

  def update
    @sub_task = SubTask.find(params[:id])
    @sub_task.update(params_sub_task)
    redirect_to sub_task_path(@sub_task.id)
  end

  def destroy
    @sub_task = SubTask.find(params[:id])
    @sub_task.destroy
    redirect_to user_main_tasks_path(current_user.id)
  end

  def add_today
    @sub_task = SubTask.find(params[:id])
    @sub_task.update(is_today_task: "true" )
    redirect_to user_main_tasks_path(@sub_task.main_task.user_id)
  end

  def remove_today
    @sub_task = SubTask.find(params[:id])
    @sub_task.update(is_today_task: "false" )
    redirect_to user_main_tasks_path(@sub_task.main_task.user_id)
  end

  def task_status_to_incomplete
    @sub_task = SubTask.find(params[:id])
    @sub_task.update(status: 0)
    @main_task = @sub_task.main_task
    @main_task.update(status: 0)
    redirect_to user_main_tasks_path(@sub_task.main_task.user_id)
  end

  def task_status_to_done
    @sub_task = SubTask.find(params[:id])
    @sub_task.update(status: 1)
    @main_task = @sub_task.main_task
    if @main_task.sub_tasks.count == @main_task.sub_tasks.where(status: 1).count
      @main_task.update(status: 1)
    end
    redirect_to user_main_tasks_path(@sub_task.main_task.user_id)
  end

  def task_status_to_deleted
    @sub_task = SubTask.find(params[:id])
    @sub_task.update(status: 2)
    redirect_to user_main_tasks_path(@sub_task.main_task.user_id)
  end

  private
  def params_sub_task
     params.require(:sub_task).permit(:main_task_id, :sub_task, :memo, :due_date, :is_today_task, :status)
  end

end