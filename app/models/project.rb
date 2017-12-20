class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy, -> { order(position: :asc) }
  belongs_to :user
end
