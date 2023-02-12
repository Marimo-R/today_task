class ChangeCloumnsNotnullAddRelationships < ActiveRecord::Migration[6.1]
  def change
    change_column :relationships, :follower_id, :integer, null: false
    change_column :relationships, :followed_id, :integer, null: false
    change_column :relationships, :status, :integer, null: false
  end
end
