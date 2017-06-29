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

end
