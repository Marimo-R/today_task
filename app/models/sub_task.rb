class SubTask < ApplicationRecord
  belongs_to :main_task
  enum status: { incomplete: 0, done: 1, deleted: 2 }
end
