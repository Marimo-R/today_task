class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top, :about]

  def not_following?
    user = User.find(params[:user_id])
    if current_user.following.include?(user)
      relationship = Relationship.find_by(follower_id: current_user.id, followed_id: user.id)
      return relationship.status == 0
    else
      current_user.following.exclude?(user)
    end
  end

  def is_matching_login_user_or_follower
    user_id = params[:user_id].to_i
    login_user_id = current_user.id
    if(user_id != login_user_id) && (not_following?)
      redirect_to root_path
    end
  end

end