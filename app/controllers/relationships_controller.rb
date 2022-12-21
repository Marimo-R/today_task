class RelationshipsController < ApplicationController

  def index
    #リクエスト新規作成用のモデル
    @relationship = Relationship.new
    #リクエストしたものの一覧
    @active_request_relationships = Relationship.where(follower_id: current_user.id)
    @active_request_relationships = @active_request_relationships.where(status: 0)
    #リクエストされたものの一覧
    @passive_request_relationships = Relationship.where(followed_id: current_user.id)
    @passive_request_relationships = @passive_request_relationships.where(status: 0)
    #フォロワー一覧
    @passive_relationships = Relationship.where(followed_id: current_user.id)
    @passive_relationships = @passive_relationships.where(status: 1)
    #フォロー一覧
    @active_relationships = Relationship.where(follower_id: current_user.id)
    @active_relationships = @active_relationships.where(status: 1)
  end

  def follow_request
    @main_task = MainTask.new
    @main_task.user_id = current_user.id
    @relationship = Relationship.new
    @relationship.follower_id = current_user.id
    @followed_user = User.find_by(email: params_relationship["email"])
    @relationship.followed_id = @followed_user.id
    @relationship.status = 0
    @relationship.save
    redirect_to relationships_path(current_user.id)
  end

  def accept
    @relationship = Relationship.find(params[:id])
    @relationship.update(status: 1)
    redirect_to relationships_path(current_user.id)
  end

  def unfollow
    @relationship = Relationship.find(params[:id])
    @relationship.destroy
    redirect_to relationships_path(current_user.id)
  end

   private
  def params_relationship
    params.require(:relationship).permit(:email)
  end
end
