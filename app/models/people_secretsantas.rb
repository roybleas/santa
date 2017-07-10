# == Schema Information
#
# Table name: people_secretsantas
#
#  id                :integer          not null, primary key
#  year              :integer          not null
#  person_id         :integer
#  santa_id          :integer
#  partner_id        :integer
#  previous_santa_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class PeopleSecretsantas < ActiveRecord::Base
include ActiveModel::Validations
include Santavalidations

  belongs_to :person
  belongs_to :santa, :class_name => 'Person', :foreign_key => 'santa_id'
  belongs_to :partner, :class_name => 'Person', :foreign_key => 'partner_id'
  belongs_to :previous_santa, :class_name => 'Person', :foreign_key => 'previous_santa_id'

  validates_with Santa_validator

  scope :join_self_as_s2, -> {joins("INNER join people_secretsantas s2 on people_secretsantas.person_id = s2.person_id")}
  scope :where_this_year_and_s2_last_year, ->(this_year) {where("people_secretsantas.year = ? and s2.year = ?",this_year,this_year - 1 )}
  scope :selecting_this_year_id_and_last_year_santa_id, -> {select("people_secretsantas.id,s2.santa_id as last_year_santa_id")}
end
