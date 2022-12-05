class Category < ApplicationRecord
  belongs_to :user
  has_many :main_tasks
end