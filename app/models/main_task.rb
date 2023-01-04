class MainTask < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :sub_tasks, dependent: :destroy
  validates :main_task, presence: true
  enum status: { incomplete: 0, done: 1, deleted: 2 }
end