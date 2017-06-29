# == Schema Information
#
# Table name: people_secretsantas
#
#  id                :integer          not null, primary key
#  year              :integer          not null
#  person_id         :integer
#  santa_id          :integer
#  partner_id        :integer
#  previous_santa_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe PeopleSecretsantas, type: :model do
  context "validation" do
    let (:this_secretsanta) {PeopleSecretsantas.create(year: 2015)}
    it "is valid with a year" do
      expect(this_secretsanta).to be_valid
    end
    it "is invalid without a year" do
      expect { PeopleSecretsantas.create() }.to raise_error(ActiveRecord::StatementInvalid, /not-null constraint/)
    end
    it "is invalid to be your own santa" do
      this_secretsanta.person_id = 1
      this_secretsanta.santa_id = this_secretsanta.person_id
      this_secretsanta.valid?
      expect(this_secretsanta.errors[:santa_id]).to include("Can't be your own Santa")
    end
  end
  context "associations" do
    before(:context) do
      @secretsanta = FactoryGirl.create(:secretsanta_with_santa_partner_previous)
      @person = Person.find(@secretsanta.person_id)
      @santa = Person.find(@secretsanta.santa_id)
      @partner = Person.find(@secretsanta.partner_id)
      @previous_santa = Person.find(@secretsanta.previous_santa_id)
    end
    context "for secretsanta" do
        it "has a person" do
          expect(@secretsanta.person).to eq(@person)
        end
        it "has a santa" do
          expect(@secretsanta.santa).to eq(@santa)
        end
        it "has a partner" do
          expect(@secretsanta.partner).to eq(@partner)
        end
        it "has a previous_santa" do
          expect(@secretsanta.previous_santa).to eq(@previous_santa)
        end
    end
    context "for person" do
      it "has people_secretsantas" do
        expect(@person.people_secretsantas.first).to eq(@secretsanta)
      end
      it "has santas" do
        expect(@santa.santas.first).to eq(@secretsanta)
      end
      it "has partners" do
        expect(@partner.partners.first).to eq(@secretsanta)
      end
      it "has previous_santas" do
        expect(@previous_santa.previous_santas.first).to eq(@secretsanta)
      end
    end

  end
end
