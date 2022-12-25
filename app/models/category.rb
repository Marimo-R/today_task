class Category < ApplicationRecord
  belongs_to :user
  has_many :main_tasks
  
  validates :category, presence: true
end