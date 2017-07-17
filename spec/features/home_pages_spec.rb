require 'rails_helper'

RSpec.feature "HomePages", type: :feature do
  scenario "redirects to load if no current santa lists loaded" do
    visit root_path
    expect(current_path).to eq load_path
  end

  scenario "show latest list of secret santa participants" do
    ps = FactoryGirl.create(:secretsanta_with_santa_partner_previous)
    p = Person.find(ps.person_id)
    s = Person.find(ps.santa_id)
    partner = Person.find(ps.partner_id)
    previous = Person.find(ps.previous_santa_id)

    visit root_path

    expect(current_path).to eq root_path

    expect(page).to have_css("h4", "Secret Santa participants for #{ps.year}")
    expect(page).to have_css("table")
    [/\AParticipant\z/ , /\ASecret Santa for\z/, /\APartner\z/, /\ASecret Santa from last year\z/ ].each do |header|
      expect(page).to have_css("th", text: header)
    end
    expect(page).to have_css("tbody tr td", text: p.name)
    expect(page).to have_css("tbody tr td", text: s.name)
    expect(page).to have_css("tbody tr td", text: partner.name)
    expect(page).to have_css("tbody tr td", text: previous.name)

  end

  scenario "ignores missing santa, partner and previous_santa values" do
    ps = FactoryGirl.create(:people_secretsanta)
    p = Person.find(ps.person_id)

    visit root_path

    expect(page).to have_css("tbody tr td", text: p.name)
    page.assert_selector('tbody tr td', :count => 4)

  end
  context "navigation menu" do
    before(:example) do
      ps = FactoryGirl.create(:people_secretsanta)
    end
    scenario "import view" do
      visit root_path
      click_link("Import")
      expect(current_path).to eq load_path
      expect(within("//nav"){ find(:xpath, ".//ul/li[contains(@class, 'active')]/a").text }).to eq "Import"
    end
    scenario "home view" do
      visit load_path
      click_link("Home")
      expect(current_path).to eq root_path
      expect(within("//nav"){ find(:xpath, ".//ul/li[contains(@class, 'active')]/a").text }).to eq "Home"
      visit load_path
      click_link("Secret Santa")
      expect(current_path).to eq root_path
      expect(within("//nav"){ find(:xpath, ".//ul/li[contains(@class, 'active')]/a").text }).to eq "Home"
    end
    scenario "archives view" do
      visit root_path
      click_link("Previous Years")
      expect(current_path).to eq archives_path
      expect(within("//nav"){ find(:xpath, ".//ul/li[contains(@class, 'active')]/a").text }).to eq "Previous Years"
    end
  end
end
