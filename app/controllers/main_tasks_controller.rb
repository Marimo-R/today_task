class MainTasksController < ApplicationController
  before_action :is_matching_login_user_or_follower, only: [:index, :calendar]
  before_action :is_matching_login_user_or_follower_for_main_task, only: [:show]
  before_action :is_match_login_user_and_url, except: [:index, :show, :calendar]

  def index
    @user = User.find(params[:user_id])
    @main_tasks = @user.main_tasks
    #Today or Notでの絞り込み機能
    if params[:today].present?
      @main_tasks = @main_tasks.where(is_today_task: true)
    end
    #@checked = params[:status]
    #メインステータスでの絞り込み機能
    if params[:status].present?
      @main_tasks = @main_tasks.where(status: params[:status])
    end
    #カテゴリでの絞り込み機能
    if params[:category].present?
      @main_tasks = @main_tasks.where(category: params[:category])
    end
    #メインタスクの並び替え機能
    if params[:order].to_i == 1
      @main_tasks = @main_tasks.order(:main_task)
    elsif params[:order].to_i == 2
      @main_tasks = @main_tasks.order(Arel.sql("due_date IS NULL"), :due_date)
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
    if @main_task.save
      flash[:success] = "メインタスクを作成しました"
      redirect_to user_main_tasks_path(@main_task.user_id)
    else
      @categories = Category.where(user_id: params[:user_id])
      render :new
    end
  end

  def edit
    @main_task = MainTask.find(params[:id])
    @categories = Category.where(user_id: params[:user_id])
  end

  def update
    @main_task = MainTask.find(params[:id])
    if @main_task.update(params_main_task)
      flash[:success] = "メインタスクを更新しました"
      redirect_to user_main_tasks_path(@main_task.user_id)
    else
      @categories = Category.where(user_id: params[:user_id])
      render :edit
    end
  end

  def destroy
    @main_task = MainTask.find(params[:id])
    @main_task.destroy
    flash[:danger] = "メインタスクを削除しました"
    redirect_to user_main_tasks_path(@main_task.user_id, status: params[:status], category: params[:category], order: params[:order], today: params[:today])
  end

  def calendar
    @user = User.find(params[:user_id])
    @main_tasks = MainTask.where(user_id: params[:user_id])
  end

  def add_today
    @main_task = MainTask.find(params[:id])
    @main_task.update(is_today_task: "true" )
    redirect_to user_main_tasks_path(@main_task.user_id, status: params[:status], category: params[:category], order: params[:order], today: params[:today])
  end

  def remove_today
    @main_task = MainTask.find(params[:id])
    @main_task.update(is_today_task: "false" )
    @sub_tasks = @main_task.sub_tasks
    @sub_tasks.update(is_today_task: "false")
    redirect_to user_main_tasks_path(@main_task.user_id, status: params[:status], category: params[:category], order: params[:order], today: params[:today])
  end

  def task_status_to_incomplete
    @main_task = MainTask.find(params[:id])
    @main_task.update(status: 0)
    redirect_to user_main_tasks_path(@main_task.user_id, status: params[:status], category: params[:category], order: params[:order], today: params[:today])
  end

  def task_status_to_done
    @main_task = MainTask.find(params[:id])
    @main_task.update(status: 1)
    @sub_tasks = @main_task.sub_tasks
    @sub_tasks.each do |sub_task|
      sub_task.update(status: 1)
    end
    redirect_to user_main_tasks_path(@main_task.user_id, status: params[:status], category: params[:category], order: params[:order], today: params[:today])
  end

  #def task_status_to_deleted
    #@main_task = MainTask.find(params[:id])
    #@main_task.update(status: 2)
    #redirect_to user_main_tasks_path(@main_task.user_id, status: params[:status], catergory: params[:cagtegory], order: params[:order])
  #end

  #def today_index
    #@user = User.find(params[:user_id])
    #@main_tasks = @user.main_tasks
    #@main_tasks = @main_tasks.where(is_today_task: true)
    #@checked = params[:status]
    #メインステータスでの絞り込み機能
    #if params[:status].present?
      #@main_tasks = @main_tasks.where(status: params[:status])
    #end
    #カテゴリでの絞り込み機能
    #if params[:category].present?
      #@main_tasks = @main_tasks.where(category: params[:category])
    #end
    #メインタスクの並び替え機能
    #if params[:order].to_i == 1
      #@main_tasks = @main_tasks.order(:main_task)
    #elsif params[:order].to_i == 2
      #@main_tasks = @main_tasks.order(Arel.sql("due_date IS NULL"), :due_date)
    #end
  #end

  private
  def params_main_task
    params.require(:main_task).permit(:category_id, :main_task, :memo, :due_date, :is_today_task, :user_id, :status)
  end

  def find_user_from_main_task_show
    main_task = MainTask.find(params[:id])
    @user = main_task.user
    @main_task_user_id = main_task.user_id
  end

  def is_match_login_user_and_url
    user_id = params[:user_id].to_i
    login_user = current_user
    if(user_id != login_user.id)
      redirect_to root_path
    end
  end

  def not_following_for_main_task?
    find_user_from_main_task_show
    if current_user.following.include?(@user)
      relationship = Relationship.find_by(follower_id: current_user.id, followed_id: @main_task_user_id)
      return relationship.status == 0
    else
      return current_user.following.exclude?(@user)
    end
  end

  def is_matching_login_user_or_follower_for_main_task
    find_user_from_main_task_show
    login_user_id = current_user.id
    if(@main_task_user_id != login_user_id) && (not_following_for_main_task?)
      redirect_to root_path
    end
  end
end