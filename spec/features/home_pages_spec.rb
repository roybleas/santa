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
    ['Name' , 'Santa', 'Partner', 'Santa from last year' ].each do |th|
      expect(page).to have_css("th", text: th)
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
end
