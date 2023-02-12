class SubTask < ApplicationRecord
  belongs_to :main_task
  validates :sub_task, presence: true
  enum status: { incomplete: 0, done: 1 }
end
