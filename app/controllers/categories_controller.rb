class CategoriesController < ApplicationController
  def create
    @category = Category.new(params_category)
    @category.user_id = current_user.id
    @category.save
    redirect_to categories_path
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
    @category.update(params_category)
    redirect_to categories_path
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path
  end

  private
  def params_category
    params.require(:category).permit(:category)
  end
end