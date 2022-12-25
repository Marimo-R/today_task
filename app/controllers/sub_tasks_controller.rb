class SubTasksController < ApplicationController
  before_action :is_matching_login_user_or_follower_for_sub_task, only: [:show]
  before_action :is_match_login_user, except: [:new, :create, :show]

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
    @main_tasks = MainTask.where(user_id: current_user.id)
  end

  def update
    @sub_task = SubTask.find(params[:id])
    @sub_task.update(params_sub_task)
    redirect_to sub_task_path(@sub_task.id)
  end

  def destroy
    @sub_task = SubTask.find(params[:id])
    @sub_task.destroy
    redirect_to user_main_tasks_path(@sub_task.main_task.user_id, status: params[:status], category: params[:category], order: params[:order], today: params[:today])
  end

  def add_today
    @sub_task = SubTask.find(params[:id])
    @sub_task.update(is_today_task: "true")
    @main_task = @sub_task.main_task
    @main_task.update(is_today_task: "true")
    redirect_to user_main_tasks_path(@sub_task.main_task.user_id, status: params[:status], category: params[:category], order: params[:order], today: params[:today])
  end

  def remove_today
    @sub_task = SubTask.find(params[:id])
    @sub_task.update(is_today_task: "false" )
    redirect_to user_main_tasks_path(@sub_task.main_task.user_id, status: params[:status], category: params[:category], order: params[:order], today: params[:today])
  end

  def task_status_to_incomplete
    @sub_task = SubTask.find(params[:id])
    @sub_task.update(status: 0)
    @main_task = @sub_task.main_task
    @main_task.update(status: 0)
    redirect_to user_main_tasks_path(@sub_task.main_task.user_id, status: params[:status], category: params[:category], order: params[:order], today: params[:today])
  end

  def task_status_to_done
    @sub_task = SubTask.find(params[:id])
    @sub_task.update(status: 1)
    @main_task = @sub_task.main_task
    if @main_task.sub_tasks.count == @main_task.sub_tasks.where(status: 1).count
      @main_task.update(status: 1)
    end
    redirect_to user_main_tasks_path(@sub_task.main_task.user_id, status: params[:status], category: params[:category], order: params[:order], today: params[:today])
  end

  #def task_status_to_deleted
    #@sub_task = SubTask.find(params[:id])
    #@sub_task.update(status: 2)
   #redirect_to user_main_tasks_path(@sub_task.main_task.user_id, status: params[:status], category: params[:category], order: params[:order])
  #end

  private
  def params_sub_task
     params.require(:sub_task).permit(:main_task_id, :sub_task, :memo, :due_date, :is_today_task, :status)
  end

  def find_user_from_sub_task
    sub_task = SubTask.find(params[:id])
    main_task = sub_task.main_task
    @user = main_task.user
  end

  def is_match_login_user
    find_user_from_sub_task
    #sub_task = SubTask.find(params[:id])
    #main_task = sub_task.main_task
    #user = main_task.user
    login_user = current_user
    if(@user.id != login_user.id)
      redirect_to root_path
    end
  end

  def not_following_for_sub_task?
    find_user_from_sub_task
    #sub_task = SubTask.find(params[:id])
    #main_task = sub_task.main_task
    #user = main_task.user
    if current_user.following.include?(@user)
      relationship = Relationship.find_by(follower_id: current_user.id, followed_id: @user.id)
      return relationship.status == 0
    else
      current_user.following.exclude?(user)
    end
  end

  def is_matching_login_user_or_follower_for_sub_task
    find_user_from_sub_task
    #sub_task = SubTask.find(params[:id])
    #main_task = sub_task.main_task
    #user = main_task.user
    user_id = @user.id
    login_user_id = current_user.id
    if(user_id != login_user_id) && (not_following_for_sub_task?)
      redirect_to root_path
    end
  end

end