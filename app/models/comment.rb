class Comment < ApplicationRecord
  belongs_to :task
  default_scope { order(created_at: :desc) }
  mount_uploader :image, ImageUploader
end
