class MainTasksController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @main_tasks = @user.main_tasks
    #@checked = params[:status]
    if params[:status].present?
      @main_tasks = @main_tasks.where(status: params[:status])
    end
    if params[:category].present?
      @main_tasks = @main_tasks.where(category: params[:category])
    end
  end

  def show
    @main_task = MainTask.find(params[:id])
  end

  def new
    @main_task = MainTask.new
    @categories = Category.where(user_id: params[:user_id])
  end

  def create
    @main_task = MainTask.new(params_main_task)
    @main_task.user_id = current_user.id
    @main_task.save
    redirect_to user_main_tasks_path(@main_task.user_id)
  end

  def edit
    @main_task = MainTask.find(params[:id])
    @categories = Category.where(user_id: params[:user_id])
  end

  def update
    @main_task = MainTask.find(params[:id])
    @main_task.update(params_main_task)
    redirect_to user_main_tasks_path(@main_task.user_id)
  end

  def destroy
    @main_task = MainTask.find(params[:id])
    @main_task.destroy
    redirect_to user_main_tasks_path(@main_task.user_id)
  end

  def add_today
    @main_task = MainTask.find(params[:id])
    @main_task.update(is_today_task: "true" )
    redirect_to user_main_tasks_path(@main_task.user_id)
  end

  def remove_today
    @main_task = MainTask.find(params[:id])
    @main_task.update(is_today_task: "false" )
    redirect_to user_main_tasks_path(@main_task.user_id)
  end

  def task_status_to_incomplete
    @main_task = MainTask.find(params[:id])
    @main_task.update(status: 0)
    redirect_to user_main_tasks_path(@main_task.user_id)
  end

  def task_status_to_done
    @main_task = MainTask.find(params[:id])
    @main_task.update(status: 1)
    @sub_tasks = @main_task.sub_tasks
    @sub_tasks.each do |sub_task|
      sub_task.update(status: 1)
    end
    redirect_to user_main_tasks_path(@main_task.user_id)
  end

  def task_status_to_deleted
    @main_task = MainTask.find(params[:id])
    @main_task.update(status: 2)
    redirect_to user_main_tasks_path(@main_task.user_id)
  end

  private
  def params_main_task
    params.require(:main_task).permit(:category_id, :main_task, :memo, :due_date, :is_today_task, :user_id, :status)
  end
end