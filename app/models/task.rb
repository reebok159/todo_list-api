class Task < ApplicationRecord
  acts_as_list scope: :project

  belongs_to :project
  has_many :comments, dependent: :destroy

  validates :name, presence: true
end
