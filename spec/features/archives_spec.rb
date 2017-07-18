require 'rails_helper'

RSpec.feature "Archives", type: :feature do
  scenario "Show no archives exist message " do
    visit archives_path
    expect(page).to have_css("h4", "Secret Santa participants from previous years")
    expect(page).to have_content("No previous participant lists")
  end

  scenario "Show a list of each previous year that have participants in descending order " do
    ps1 = FactoryGirl.create(:people_secretsanta, year: 2015)
    ps2 = FactoryGirl.create(:people_secretsanta, year: 2016)
    ps3 = FactoryGirl.create(:people_secretsanta, year: 2016)
    ps4 = FactoryGirl.create(:people_secretsanta, year: 2017)

    visit archives_path

    expect(page).to_not have_content("No previous participant lists")
    expect(page).to have_content("2015")
    expect(page).to_not have_content("2017")
    expect(page).to have_selector('a', text: 2016, count: 1)
    expect(page).to have_xpath('//ul/li[1]/a',text: '2016' )
    expect(page).to have_link("2016")

  end
  scenario "Show no archives exist message when only current year exists" do
    ps4 = FactoryGirl.create(:people_secretsanta)
    visit archives_path

    expect(page).to have_content("No previous participant lists")
  end

  scenario "show archives from navigation bar" do
    visit root_path
    click_link("Previous Years")
    expect(current_path).to eq archives_path
  end

end
