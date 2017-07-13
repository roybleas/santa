require 'rails_helper'

RSpec.describe "SecretSanta" do
  context "create SecretSantas " do
    it "initializes a SecretSanta class from people_secretsanta object" do
      ps = FactoryGirl.create(:secretsanta_with_santa_partner_previous)

      santa = SecretSanta.new(ps)
      expect(santa.santa_id).to be_nil
      expect(santa.valid?(ps.person_id)).to be_falsey
      expect(santa.valid?(ps.partner_id)).to be_falsey
      expect(santa.valid?(ps.previous_santa_id)).to be_falsey
    end

    it "creates a Secret Santa with minimum values" do
      ps = FactoryGirl.create(:people_secretsanta)
      p = FactoryGirl.create(:person)

      santa = SecretSanta.new(ps)
      expect(santa.santa_id).to be_nil
      expect(santa.valid?(ps.person_id)).to be_falsey
      expect(santa.valid?(p.id)).to be_truthy
    end

    it "treats a nil gift_recipient_id as invalid" do
      ps = FactoryGirl.create(:people_secretsanta)
      santa = SecretSanta.new(ps)
      expect(santa.valid?(nil)).to be_falsey
    end
  end

end
