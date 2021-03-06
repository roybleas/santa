# == Schema Information
#
# Table name: people
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Person < ActiveRecord::Base

  validates :name, presence: true, length: {maximum: 50}, uniqueness: true

  has_many :people_secretsantas, :class_name => 'PeopleSecretsantas'
  has_many :santas, :class_name => 'PeopleSecretsantas', :foreign_key => 'santa_id'
  has_many :partners, :class_name => 'PeopleSecretsantas', :foreign_key => 'partner_id'
  has_many :previous_santas, :class_name => 'PeopleSecretsantas', :foreign_key => 'previous_santa_id'

  scope :include_people_secretsantas, -> {includes(:people_secretsantas).
    references(:people_secretsantas)}
  scope :include_santas, -> {includes(:santas).references(:santas)}
  scope :include_partners, -> {includes(:partners).references(:partners)}
  scope :include_previous_santas, -> {includes(:previous_santas).references(:previous_santas)}

  scope :non_participants, -> {
    select("people.id ").
    joins("left join people_secretsantas on people.id = people_secretsantas.person_id" \
      " left join people_secretsantas partner on people.id = partner.partner_id" \
      " left join people_secretsantas santa on people.id = santa.santa_id" \
      " left join people_secretsantas previous on people.id = previous.previous_santa_id").
    where("people_secretsantas.person_id is null" \
      " and partner.partner_id is null and santa.santa_id is null" \
      " and previous.previous_santa_id is null ")
  }
end
