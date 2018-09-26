class Comment < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :task

  validates :text, length: { in: 10..256 }
end
