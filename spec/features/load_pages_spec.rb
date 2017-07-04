require 'rails_helper'

RSpec.feature "HomePages", type: :feature do
  scenario "Shows the current year" do
    visit load_path

    expect(page.has_field?("currentyear", :with => Date.today.year))
  
  end


end
