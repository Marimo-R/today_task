class UsersController < ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update(params_user)
    redirect_to users_my_page_path
  end

  private
  def params_user
    params.require(:user).permit(:name, :email, :is_deleted)
  end
end
