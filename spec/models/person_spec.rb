# == Schema Information
#
# Table name: people
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Person, type: :model do
	before(:example) do
		@person = Person.new(
      name: "Fred Flintstone",
      email: "fred@boulder.com"
    )
	end
	let(:valid_emails)   { %w[FRED@boulder.COM THE_ROCK-COMpany@boulder.rock.org first.last@rock.jp] }
	let(:invalid_emails) { %w[fred@boulde,com barney_at_boulder.org wilma@boulder.com@rock.org pebble@home+boulder.com ] }

  it "is valid with a name and email address" do
    expect(@person).to be_valid
  end
  it "is invalid without a name" do
    @person.name = nil
    @person.valid?
    expect(@person.errors[:name]).to include("can't be blank")
  end
  it "is invalid without an email address" do
    @person.email = nil
		@person.valid?
    expect(@person.errors[:email]).to include("can't be blank")
  end
	it "is invalid when name is longer than 50 characters" do
		@person.name = "x" * 51
		@person.valid?
		expect(@person.errors[:name]).to include("is too long (maximum is 50 characters)")
	end
	it "is invalid when email is longer than 255 characters" do
		@person.email = "x" * 256
		@person.valid?
		expect(@person.errors[:email]).to include("is too long (maximum is 255 characters)")
	end
	it "accepts valid email address" do
		valid_emails.each do | email_address_valid |
      @person.email = email_address_valid
			expect(@person).to be_valid
		end
	end
	it "rejects invalid email address" do
		invalid_emails.each do | email_address_invalid |
			@person.email = email_address_invalid
			@person.valid?
			expect(@person.errors[:email]).to include("is invalid")
		end
	end
  it "is invalid with a duplicate name" do
    duplicate_person = Person.create(name: "Fred Flintstone", email: "fredflintstone@boulder.com")
		expect(duplicate_person).to be_valid
		@person.save
		expect(@person.errors[:name]).to include("has already been taken")
  end

	context "extract non participant" do
		it "when person no longer belongs to people_secretsantas" do
			p1 = FactoryGirl.create(:person)
			p2 = FactoryGirl.create(:person)
			ps = FactoryGirl.create(:people_secretsanta)

			expect(Person.non_participants.all).to include(p1,p2)
		end
		it "when person no longer is a santa_id" do
			p1 = FactoryGirl.create(:person)
			p2 = FactoryGirl.create(:person)
			ps1 = FactoryGirl.create(:people_secretsanta)
			ps2 = FactoryGirl.create(:people_secretsanta, santa_id: p2.id)

			expect(Person.non_participants.all).to include(p1)
		end
		it "when person no longer is a partner_id" do
			p1 = FactoryGirl.create(:person)
			p2 = FactoryGirl.create(:person)
			ps1 = FactoryGirl.create(:people_secretsanta)
			ps2 = FactoryGirl.create(:people_secretsanta, partner_id: p2.id)

			expect(Person.non_participants.all).to include(p1)
		end
		it "when person no longer is a previous_santa_id" do
			p1 = FactoryGirl.create(:person)
			p2 = FactoryGirl.create(:person)
			ps1 = FactoryGirl.create(:people_secretsanta)
			ps2 = FactoryGirl.create(:people_secretsanta, previous_santa_id: p1.id)

			expect(Person.non_participants.all).to include(p2)
		end
	end
end
