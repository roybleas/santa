# == Schema Information
#
# Table name: people
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Person < ActiveRecord::Base
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50}, uniqueness: true
  validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL }

  has_many :people_secretsantas, :class_name => 'PeopleSecretsantas'
  has_many :santas, :class_name => 'PeopleSecretsantas', :foreign_key => 'santa_id'
  has_many :partners, :class_name => 'PeopleSecretsantas', :foreign_key => 'partner_id'
  has_many :previous_santas, :class_name => 'PeopleSecretsantas', :foreign_key => 'previous_santa_id'

  scope :include_people_secretsantas, -> {includes(:people_secretsantas).references(:people_secretsantas)}
  scope :include_santas, -> {includes(:santas).references(:santas)}
  scope :include_partners, -> {includes(:partners).references(:partners)}
  scope :include_previous_santas, -> {includes(:previous_santas).references(:previous_santas)}

end
