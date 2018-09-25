class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  has_many :projects, dependent: :destroy

  validates :email, uniqueness: true, presence: true
  validates :password, length: { is: 8 },
                       format: { with: /\A[A-Za-z\d]+\z/, message: I18n.t('models.user.errors.format') },
                       unless: ->(u) { u.password.nil? }

  validates_confirmation_of :password
end
