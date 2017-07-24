# == Schema Information
#
# Table name: people
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person do
    sequence(:name) { |n| "person#{n}" }

    factory :santa do
      sequence(:name) { |n| "santa_#{n}" }
    end
    factory :partner do
      sequence(:name) { |n| "partner_#{n}" }
    end
    factory :previous_santa do
      sequence(:name) { |n| "previous_santa_#{n}" }
    end
  end
end
