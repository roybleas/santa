require 'rails_helper'


RSpec.describe "HomePages" do
  context "creates people_secretsanta records" do

    before(:context) do
      @this_year = Date.today.year
      @participant_1 = Participant.new("person_1","person_1@email.com")
      @participant_1.person.save!
      @participant_2 = Participant.new("person_2","person_2@email.com")
      @participant_2.person.save!
      @participant_2.partner = @participant_1.name
      @participant_1.partner = @participant_2.name
      @previous_person_santa_1 = FactoryGirl.create(:people_secretsanta, year: @this_year - 1)
      @previous_person_santa_2 = FactoryGirl.create(:people_secretsanta, year: @this_year - 1)
      @previous_person_santa_1.santa_id = @previous_person_santa_2.id
      @previous_person_santa_1.save
      @participant_3 = Participant.new(Person.find(@previous_person_santa_1.person_id).name,"person@email.com")
      @participant_3.person.save!
    end

    it "creates a santa record" do
      participants = [@participant_1]
      santalist = SantaList.new("2018",participants)
      santalist.add_people

      person_santa = PeopleSecretsantas.find_by_person_id(@participant_1.person.id)
      expect(person_santa).to_not be_nil
      expect(person_santa.year).to eq 2018
      expect(person_santa.person_id).to eq @participant_1.person.id
    end

    it "creates a pair of partner santa records" do
      participants = [@participant_2,@participant_1]
      santalist = SantaList.new("2018",participants)
      santalist.add_people

      person_santa2 = PeopleSecretsantas.find_by_person_id(@participant_2.person.id)
      expect(person_santa2).to_not be_nil
      person_santa1 = PeopleSecretsantas.find_by_person_id(@participant_1.person.id)
      expect(person_santa1.partner_id).to eq @participant_2.person.id
      expect(person_santa2.partner_id).to eq @participant_1.person.id
    end

    it "includes previous years santa id if participant has same name" do
      this_year = Date.today.year
      last_year = this_year - 1
      s1 = FactoryGirl.create(:people_secretsanta, year: last_year)
      s2 = FactoryGirl.create(:people_secretsanta, year: last_year)
      s2.santa_id = s1.person_id
      s2.save
      s3 = FactoryGirl.create(:people_secretsanta, year: this_year, person_id: s2.person_id)
      s4 = FactoryGirl.create(:people_secretsanta, year: this_year)
      santalist = SantaList.new(this_year.to_s,[])
      santalist.update_with_previous_santas
      expect(PeopleSecretsantas.find_by_person_id(s4.person.id).previous_santa_id).to be_nil
      expect(PeopleSecretsantas.find_by_person_id(s3.person.id).previous_santa_id).to eq s1.person_id
    end

    it "it only includes for the previous years and ignores earlier years" do
      this_year = Date.today.year
      previous_year = this_year - 2
      s1 = FactoryGirl.create(:people_secretsanta, year: previous_year)
      s2 = FactoryGirl.create(:people_secretsanta, year: previous_year)
      s2.santa_id = s1.person_id
      s2.save
      s3 = FactoryGirl.create(:people_secretsanta, year: this_year, person_id: s2.person_id)
      s4 = FactoryGirl.create(:people_secretsanta, year: this_year)
      santalist = SantaList.new(this_year.to_s,[])
      santalist.update_with_previous_santas

      expect(PeopleSecretsantas.find_by_person_id(s4.person.id).previous_santa_id).to be_nil
      expect(PeopleSecretsantas.find_by_person_id(s3.person.id).previous_santa_id).to be_nil
    end

  end
end
