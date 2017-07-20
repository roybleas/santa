require 'rails_helper'

RSpec.feature "People", type: :feature do
  context "index" do
    scenario "show no participants available message" do
      visit people_path
      expect(page).to have_css("h4", text:  "Secret Santa participants")
      expect(page).to have_content("No participants")
    end

    scenario "show some participants" do
      p = FactoryGirl.create(:person)
      ps = FactoryGirl.create(:people_secretsanta, person_id: p.id)

      visit people_path

      expect(page).to have_link(p.name)
      expect(page).to have_link(ps.year)
    end

    context "links to " do
      before(:context) do
        DatabaseCleaner.start
        @p = FactoryGirl.create(:person)
        @ps1 = FactoryGirl.create(:people_secretsanta, person_id: @p.id)
        @ps2 = FactoryGirl.create(:people_secretsanta, person_id: @p.id, year: @ps1.year - 1)
      end
      after(:context) { DatabaseCleaner.clean}

      scenario "previous year person was a participant" do
        visit people_path
        click_link(@ps2.year)
        expect(current_path).to eq people_secretsanta_path(@ps2.year)
        expect(page).to have_content(@p.name)
      end

      scenario "current year person was a participant" do
        visit people_path
        click_link(@ps1.year)
        expect(current_path).to eq root_path
        expect(page).to have_content(@p.name)
      end

      scenario "person's participation" do
        visit people_path
        click_link(@p.name)
        expect(current_path).to eq person_path(@p.id)
        expect(page).to have_content(@p.name)
      end
    end
  end

  context "show" do
    before(:context) do
      DatabaseCleaner.start
      @p = FactoryGirl.create(:person)
      @ps1 = FactoryGirl.create(:people_secretsanta, person_id: @p.id)
      @ps2 = FactoryGirl.create(:people_secretsanta, person_id: @p.id, year: @ps1.year - 1)
    end
    after(:context) { DatabaseCleaner.clean}
    
    scenario "not found" do
      visit person_path(0)
      expect(page.status_code).to eq 404
    end

    scenario "view " do
      visit person_path(@p.id)
      expect(current_path).to eq person_path(@p.id)
      expect(page).to have_css("h4", text: "Secret Santa participant: #{@p.name}")
      expect(page).to have_css("table")
      [/\AYear\z/ , /\ASecret Santa for\z/, /\APartner\z/,
         /\ASecret Santa from last year\z/ ].each do |header|
        expect(page).to have_css("th", text: header)
      end
      expect(page).to have_css("tbody tr td", text: @ps2.year)
    end

    scenario "table " do
      ps = FactoryGirl.create(:secretsanta_with_santa_partner_previous)
      p = Person.find(ps.person_id)
      s = Person.find(ps.santa_id)
      partner = Person.find(ps.partner_id)
      previous = Person.find(ps.previous_santa_id)

      visit person_path(p.id)
      expect(page).to have_css("tbody tr td", text: ps.year)
      expect(page).to have_css("tbody tr td", text: s.name)
      expect(page).to have_css("tbody tr td", text: partner.name)
      expect(page).to have_css("tbody tr td", text: previous.name)
    end
  end
end
