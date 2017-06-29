module Santavalidations
  extend ActiveSupport::Concern

  class Santa_validator <ActiveModel::Validator
    def validate(record)
      if record.person_id == record.santa_id
        record.errors[:santa_id] << "Can't be your own Santa" unless record.santa_id.nil?
      end
    end
  end
end
