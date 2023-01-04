class CategoriesController < ApplicationController
  before_action :is_match_login_user, except: [:index, :create]

  def create
    @category = Category.new(params_category)
    @category.user_id = current_user.id
    if @category.save
      flash[:success] = "カテゴリーを作成しました"
      redirect_to categories_path
    else
      @categories = current_user.categories
      render :index
    end
  end

  def index
    @category = Category.new
    @categories = current_user.categories
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(params_category)
      flash[:success] = "カテゴリーを編集しました"
      redirect_to categories_path
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:danger] = "カテゴリーを削除しました"
    redirect_to categories_path
  end

  private
  def params_category
    params.require(:category).permit(:category)
  end

  def is_match_login_user
    category = Category.find(params[:id])
    user = category.user
    login_user = current_user
    if(user.id != login_user.id)
      redirect_to root_path
    end
  end
end