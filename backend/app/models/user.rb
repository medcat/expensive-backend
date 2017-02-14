class User < ApplicationRecord
  validates :email, format: /\A[^@\s]+@[^@\s]+\z/, presence: true,
    uniqueness: true
  validates :password, length: { minimum: 6 }, confirmation: true,
    presence: true
  validates :password_confirmation, presence: true
  has_secure_password
end
