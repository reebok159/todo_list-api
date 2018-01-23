class Project < ApplicationRecord
  has_many :tasks, -> { order(position: :asc) }, dependent: :destroy
  belongs_to :user

  validates :name, presence: true, uniqueness: true
end
