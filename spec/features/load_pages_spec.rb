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

  scenario "Ignores import when no file selected" do
    visit load_path

    click_button('Import')
    expect(current_path).to eq load_path
  end

  scenario "create people records" do
    person_count = Person.count
    visit load_path
    attach_file('file', './spec/files/simple_names.csv')
    click_button('Import')
    expect(Person.count).to eq person_count + 3
  end

  scenario "update existing person" do
    person_count = Person.count
    visit load_path
    attach_file('file', './spec/files/simple_names.csv')
    click_button('Import')
    expect(Person.count).to eq person_count + 3

    person_wilma_email = Person.find_by_name('Wilma Flintstone').email
    person_count = Person.count

    visit load_path
    attach_file('file', './spec/files/simple_names2.csv')
    click_button('Import')
    expect(Person.count).to eq person_count + 1
    expect(Person.find_by_name('Wilma Flintstone').email).to_not eq person_wilma_email
  end

  scenario "create people_secretsanta records" do
    person_santa_count = PeopleSecretsantas.count
    visit load_path
    attach_file('file', './spec/files/simple_names.csv')
    click_button('Import')
    expect(PeopleSecretsantas.count).to eq person_santa_count + 3
  end

  scenario "generate Secret Santas on load" do

    next_year = PeopleSecretsantas.maximum('year')
    next_year ||= Date.today.year
    next_year =+ 1

    visit load_path
    fill_in 'currentyear', with: next_year
    attach_file('file', './spec/files/partners.csv')
    click_button('Import')

    expect(current_path).to eq root_path
    expect(PeopleSecretsantas.where.not("santa_id is null").by_year(next_year).count).to_not eq 0
    ps = PeopleSecretsantas.include_people.include_santas.by_year(next_year).order("people.name").first
  
    expect(page).to have_xpath('//tbody/tr[1]/td[1]',text: ps.person.name)
    expect(page).to have_xpath('//tbody/tr[1]/td[2]',text: ps.santa.name)
    expect(page).to have_xpath('//tbody/tr[1]/td[3]',text: ps.partner.name)
  end
end
