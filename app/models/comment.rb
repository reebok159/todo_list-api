class Comment < ApplicationRecord
  belongs_to :task
  default_scope { order(created_at: :desc) }
end
