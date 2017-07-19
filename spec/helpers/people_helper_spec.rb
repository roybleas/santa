require 'rails_helper'

RSpec.describe PeopleHelper, type: :helper do
  context "set path for year" do
    it "to previous path when not current year" do
      current_year = Date.today.year
      test_year = current_year - 1
      set_path = helper.set_path(current_year)
      expect(set_path.for_year(test_year)).to eq people_secretsanta_path(test_year)
    end
    it "to root path when current year" do
      current_year = Date.today.year
      test_year = current_year
      set_path = helper.set_path(current_year)
      expect(set_path.for_year(test_year)).to eq root_path
    end

  end
end
