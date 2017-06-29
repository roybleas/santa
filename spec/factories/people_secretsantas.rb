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

FactoryGirl.define do
  factory :people_secretsanta, :class => 'PeopleSecretsantas' do
    year 2017
    santa_id nil
    partner_id nil
    previous_santa_id nil
    person

    factory :secretsanta_with_santa, :class => 'PeopleSecretsantas' do
      santa_id { FactoryGirl.create(:santa).id }

      factory :secretsanta_with_santa_partner_previous, :class => 'PeopleSecretsantas' do
        partner_id { FactoryGirl.create(:partner).id }
        previous_santa_id { FactoryGirl.create(:previous_santa).id }
      end
    end
  end
end
