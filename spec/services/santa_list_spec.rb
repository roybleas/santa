require 'rails_helper'


RSpec.describe "Santa List" do
  context "people_secretsanta records" do

    before(:context) do
      DatabaseCleaner.start
      @this_year = Date.today.year
      @participant_1 = Participant.new("person_1")
      @participant_1.person.save!
      @participant_2 = Participant.new("person_2")
      @participant_2.person.save!
      @participant_2.partner = @participant_1.name
      @participant_1.partner = @participant_2.name
      @previous_person_santa_1 = FactoryGirl.create(:people_secretsanta, year: @this_year - 1)
      @previous_person_santa_2 = FactoryGirl.create(:people_secretsanta, year: @this_year - 1)
      @previous_person_santa_1.santa_id = @previous_person_santa_2.id
      @previous_person_santa_1.save
      @participant_3 = Participant.new(Person.find(@previous_person_santa_1.person_id).name)
      @participant_3.person.save!
    end
    after(:context) { DatabaseCleaner.clean}

    it "creates a santa record" do
      participants = [@participant_1]
      santalist = SantaList.new("2018",participants)
      santalist.add_associated_people_to_participant

      person_santa = PeopleSecretsantas.find_by_person_id(@participant_1.person.id)
      expect(person_santa).to_not be_nil
      expect(person_santa.year).to eq 2018
      expect(person_santa.person_id).to eq @participant_1.person.id
    end

    it "creates a pair of partner santa records" do
      participants = [@participant_2,@participant_1]
      santalist = SantaList.new("2018",participants)
      santalist.add_associated_people_to_participant

      person_santa2 = PeopleSecretsantas.find_by_person_id(@participant_2.person.id)
      expect(person_santa2).to_not be_nil
      person_santa1 = PeopleSecretsantas.find_by_person_id(@participant_1.person.id)
      expect(person_santa1.partner_id).to eq @participant_2.person.id
      expect(person_santa2.partner_id).to eq @participant_1.person.id
    end
    context "updates previous santa id" do
      it " if participant has same name" do
        
        this_year = Date.today.year
        last_year = this_year - 1
        s1 = FactoryGirl.create(:people_secretsanta, year: last_year)
        s2 = FactoryGirl.create(:people_secretsanta, year: last_year)
        s3 = FactoryGirl.create(:people_secretsanta, year: last_year)
        s2.santa_id = s1.person_id
        s2.save
        s1.santa_id = s2.person_id
        s1.save
        s4 = FactoryGirl.create(:people_secretsanta, year: this_year, person_id: s2.person_id)
        s5 = FactoryGirl.create(:people_secretsanta, year: this_year, person_id: s1.person_id)
        s6 = FactoryGirl.create(:people_secretsanta, year: this_year)

        santalist = SantaList.new(this_year.to_s,[])
        santalist.update_with_previous_santas

        expect(PeopleSecretsantas.find(s4.id).previous_santa_id).to eq s1.person_id
        expect(PeopleSecretsantas.find(s5.id).previous_santa_id).to eq s2.person_id
        expect(PeopleSecretsantas.find(s6.id).previous_santa_id).to be_nil
      end

      it "but ignores years earlier than previous one" do
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
    it "removes records from a previous import for the same year" do
      this_year = 2002
      last_year = this_year - 1

      s3 = FactoryGirl.create(:people_secretsanta, year: this_year, person_id: @participant_1.person.id)
      s4 = FactoryGirl.create(:people_secretsanta, year: this_year, person_id: @participant_2.person.id)
      s1 = FactoryGirl.create(:people_secretsanta, year: last_year)
      s2 = FactoryGirl.create(:people_secretsanta, year: last_year)
      s3_id = s3.id
      s4_id = s4.id
      number_of_people = Person.count

      santalist = SantaList.new(this_year.to_s,[@participant_1, @participant_2])
      santalist.add_associated_people_to_participant

      expect(PeopleSecretsantas.find_by_id(s1.id)).to_not be_nil
      expect(PeopleSecretsantas.find_by_id(s2.id)).to_not be_nil
      expect(PeopleSecretsantas.find_by_id(s3_id)).to be_nil
      expect(PeopleSecretsantas.find_by_id(s4_id)).to be_nil
      expect(PeopleSecretsantas.where(year: this_year, person_id: @participant_1.person.id)).to_not be_nil
      expect(PeopleSecretsantas.where(year: this_year, person_id: @participant_2.person.id)).to_not be_nil
      expect(Person.count).to eq number_of_people

    end
  end
end
