require 'rails_helper'

RSpec.feature "HomePages", type: :feature do
  scenario "Shows default of the current year" do
    visit load_path

    expect(page).to have_selector("input[value='#{(Date.today.year)}']")
    expect(page).to have_selector("input[type='number']")
    expect(page).to have_selector("input[min='#{(Date.today.year)}']")

  end

  scenario "Shows default of latest sanata year" do
    FactoryGirl.create(:people_secretsanta, year: 2013)
    @person_santa = FactoryGirl.create(:people_secretsanta, year: 2015)
    FactoryGirl.create(:people_secretsanta, year: 2014)

    visit load_path

    expect(page).to have_selector("input[value='#{(@person_santa.year)}']")
    expect(page).to have_selector("input[type='number']")
    expect(page).to have_selector("input[min='#{(@person_santa.year)}']")

  end




end
