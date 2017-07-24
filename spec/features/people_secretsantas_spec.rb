require 'rails_helper'

RSpec.feature "PeopleSecretsantas", type: :feature do

  context "redirect" do
    scenario "when year does not exist" do
      visit people_secretsanta_path(2016)
      expect(current_path).to eq archives_path
    end

    scenario "when year is current year" do
      ps = FactoryGirl.create(:people_secretsanta)
      visit people_secretsanta_path(ps.year)
      expect(current_path).to eq archives_path
    end

    scenario "when year is not numeric" do
      ps = FactoryGirl.create(:people_secretsanta)
      ps2 = FactoryGirl.create(:people_secretsanta, year: ps.year - 1)
      visit people_secretsanta_path("twothousandandsixteen")
      expect(current_path).to eq archives_path
    end
  end

  context "show" do
    before(:context) do
      DatabaseCleaner.start
      ps_current = FactoryGirl.create(:people_secretsanta)
      @ps = FactoryGirl.create(:secretsanta_with_santa_partner_previous, year: ps_current.year - 1)
      @p = Person.find(@ps.person_id)
      @s = Person.find(@ps.santa_id)
      @partner = Person.find(@ps.partner_id)
      @previous = Person.find(@ps.previous_santa_id)
    end
    after(:context) { DatabaseCleaner.clean}

    scenario "participants for selected year" do
      visit people_secretsanta_path(@ps.year)

      expect(current_path).to eq people_secretsanta_path(@ps.year)
      expect(page).to have_css("h4", text: "Secret Santa participants for #{@ps.year}")
      expect(page).to_not have_css("h4", text: "Current ")
      [@p.name, @s.name, @partner.name, @previous.name ].each do |this_name|
        expect(page).to have_content(this_name)
      end
    end

    scenario "creates link to person" do
      visit people_secretsanta_path(@ps.year)
      expect(current_path).to eq people_secretsanta_path(@ps.year)
      click_link(@p.name)
      expect(current_path).to eq person_path(@p.id)
    end
    scenario "creates link to santa" do
      visit people_secretsanta_path(@ps.year)
      click_link(@s.name)
      expect(current_path).to eq person_path(@s.id)
    end
    scenario "creates link to partner" do
      visit people_secretsanta_path(@ps.year)
      click_link(@partner.name)
      expect(current_path).to eq person_path(@partner.id)
    end
    scenario "creates link to previous santa" do
      visit people_secretsanta_path(@ps.year)
      click_link(@previous.name)
      expect(current_path).to eq person_path(@previous.id)
    end

    scenario "ignore links when people ids are null" do
      ps2 = FactoryGirl.create(:archived_secretsanta)
      p2 = Person.find(ps2.person_id)
      visit people_secretsanta_path(@ps.year)
      expect(current_path).to eq people_secretsanta_path(@ps.year)
      expect(page).to have_link(p2.name)
    end

  end

  scenario "Invalid Secret Santa  list" do
    ps_current = FactoryGirl.create(:people_secretsanta)
    ps1 = FactoryGirl.create(:archived_secretsanta)
    ps2 = FactoryGirl.create(:archived_secretsanta)
    ps2.update(santa_id:  nil)
    visit people_secretsanta_path(ps1.year)

    expect(page).to have_content('Warning: Participants have not all been allocated to be a Secret Santa.')
  end

  context "delete" do
    before(:each) do
      @ps_current = FactoryGirl.create(:people_secretsanta)
      ps = FactoryGirl.create(:archived_secretsanta)
      @ps2 = FactoryGirl.create(:archived_secretsanta)
      @this_year = ps.year
    end

    scenario "participants for selected year" do
      people_count = Person.count
      visit people_secretsanta_path(@this_year)
      click_link("Delete")

      expect(current_path).to eq archives_path
      expect(PeopleSecretsantas.by_year(@this_year).count).to eq 0
      expect(page).to have_content("Deleted all 2 participants for year #{@this_year}.")
      expect(Person.count).to eq people_count - 2
    end

    scenario "only participants for selected year" do
      ps_older = FactoryGirl.create(:people_secretsanta, year: @this_year - 1, person_id:  @ps2.person_id )
      people_count = Person.count

      visit archives_path
      click_link(@this_year)
      expect(current_path).to eq people_secretsanta_path(@this_year)

      click_link("Delete")

      expect(current_path).to eq archives_path
      expect(PeopleSecretsantas.by_year(@this_year).count).to eq 0
      expect(Person.count).to eq people_count - 1
      expect(page).to have_content("Deleted all 2 participants for year #{@this_year}.")
      expect(page).to have_link(ps_older.year)
      expect(page).to_not have_link(@this_year)
    end

    scenario "people who are no longer participants" do
      person = FactoryGirl.create(:person)
      people_count = Person.count

      visit people_secretsanta_path(@this_year)
      click_link("Delete")
      expect(Person.count).to eq people_count - 3
    end

    scenario "from secret santa list but keep all people as in use" do
      ps_inuse_1 = FactoryGirl.create(:people_secretsanta, year: @this_year - 1, person_id:  @ps2.person_id )
      ps_inuse_2 = FactoryGirl.create(:people_secretsanta, year: @this_year - 1, person_id: @ps_current.person_id )
      people_count = Person.count

      visit people_secretsanta_path(@this_year - 1)
      click_link("Delete")
      expect(Person.count).to eq people_count
    end

    scenario "current year" do
      people_count = Person.count
      visit root_path

      click_link("Delete")

      expect(current_path).to eq root_path
      expect(PeopleSecretsantas.by_year(@ps_current.year).count).to eq 0
      expect(page).to have_content("Deleted all 1 participants for year #{@ps_current.year}.")
      expect(Person.count).to eq people_count - 1
    end
  end
end
