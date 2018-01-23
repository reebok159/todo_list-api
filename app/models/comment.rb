class Comment < ApplicationRecord
  belongs_to :task
  default_scope { order(created_at: :desc) }
  mount_uploader :image, ImageUploader

  validates :text, length: { in: 10..256 }
end
