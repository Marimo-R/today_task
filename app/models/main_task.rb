class MainTask < ApplicationRecord
  belongs_to :user
  belongs_to :category
  enum status: { incomplete: 0, done: 1, deleted: 2 }
end