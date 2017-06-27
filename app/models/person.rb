class Person < ActiveRecord::Base
  #VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50}, uniqueness: true
  validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL }
end
