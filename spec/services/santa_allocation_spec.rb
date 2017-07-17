require 'rails_helper'

RSpec.describe "Santa Allocation" do
  context "initialize" do
    before(:context) do
      @ps1 = FactoryGirl.create(:people_secretsanta)
      ps2 = FactoryGirl.create(:people_secretsanta)
      ps3 = FactoryGirl.create(:people_secretsanta)
      ps4 = FactoryGirl.create(:people_secretsanta)
      ps5 = FactoryGirl.create(:people_secretsanta)
      @people_secretsantas = PeopleSecretsantas.find([@ps1.id, ps2.id, ps3.id, ps4.id, ps5 ])
    end

    it "creates array of santas" do
      allocation = SantaAllocation.new(@people_secretsantas)
      expect(allocation.santas.size).to eq 5
      expect(allocation.santas).to include(a_kind_of(SecretSanta))
    end

    it "creates array of gift_recipients" do
      allocation = SantaAllocation.new(@people_secretsantas)
      expect(allocation.gift_recipients.size).to eq 5
      expect(allocation.gift_recipients).to include( @ps1.person_id)
    end

    it  "by shuffling gift_recipients" do
      #note: even with 5 people the shuffle might sometimes return the same order
      # so ignore for now as tested random input has been added
      #pre_shuffle = @people_secretsantas.map { |p| p.person_id  }
      #allocation = SantaAllocation.new(@people_secretsantas)
      #expect(allocation.gift_recipients).to_not eq pre_shuffle
    end

  end
  context 'allocates' do
    before(:each) do
      @ps1 = FactoryGirl.create(:people_secretsanta)
      @ps2 = FactoryGirl.create(:people_secretsanta)
      @ps3 = FactoryGirl.create(:people_secretsanta)
      @ps4 = FactoryGirl.create(:people_secretsanta)
    end

    it " successfully 2 people to each other" do

      people_secretsantas = PeopleSecretsantas.find([@ps1.id, @ps2.id])
      pre_shuffle = people_secretsantas.map { |p| p.person_id }
      allocation = SantaAllocation.new(people_secretsantas)
      allocation.gift_recipients = pre_shuffle
      expect(allocation.generate).to be_truthy
      expect(allocation.santas[0].santa_id).to eq @ps2.person_id
      expect(allocation.santas[1].santa_id).to eq @ps1.person_id
    end

    it " successfully 4 people each with partners" do

      @ps1.update(partner_id:  @ps2.person_id)
      @ps2.update(partner_id:  @ps1.person_id)
      @ps3.update(partner_id:  @ps4.person_id)
      @ps4.update(partner_id:  @ps3.person_id)

      people_secretsantas = PeopleSecretsantas.find([@ps1.id, @ps2.id, @ps3.id, @ps4.id ] )
      pre_shuffle = people_secretsantas.map { |p|  p.person_id }
      allocation = SantaAllocation.new(people_secretsantas)
      allocation.gift_recipients = pre_shuffle
      expect(allocation.generate).to be_truthy
      expect(allocation.santas[0].santa_id).to eq @ps3.person_id
      expect(allocation.santas[1].santa_id).to eq @ps4.person_id
      expect(allocation.santas[2].santa_id).to eq @ps1.person_id
      expect(allocation.santas[3].santa_id).to eq @ps2.person_id
    end

    it " successfully 4 people each with partners and previous santa " do

      @ps1.update(partner_id:  @ps2.person_id)
      @ps2.update(partner_id:  @ps1.person_id)
      @ps3.update(partner_id:  @ps4.person_id)
      @ps4.update(partner_id:  @ps3.person_id)

      @ps1.update(previous_santa_id:  @ps3.person_id)
      @ps2.update(previous_santa_id:  @ps4.person_id)
      @ps3.update(previous_santa_id:  @ps2.person_id)
      @ps4.update(previous_santa_id:  @ps1.person_id)

      people_secretsantas = PeopleSecretsantas.find([@ps1.id, @ps2.id, @ps3.id, @ps4.id ] )
      pre_shuffle = people_secretsantas.map { |p| p.person_id }
      allocation = SantaAllocation.new(people_secretsantas)
      allocation.gift_recipients = pre_shuffle
      expect(allocation.generate).to be_truthy
      expect(allocation.santas[0].santa_id).to eq @ps4.person_id
      expect(allocation.santas[1].santa_id).to eq @ps3.person_id
      expect(allocation.santas[2].santa_id).to eq @ps1.person_id
      expect(allocation.santas[3].santa_id).to eq @ps2.person_id
    end

    it "unsuccessfully 3 people when 2 have partners" do

      @ps1.update(partner_id:  @ps2.person_id)
      @ps2.update(partner_id:  @ps1.person_id)

      people_secretsantas = PeopleSecretsantas.find([@ps2.id, @ps1.id, @ps3.id ] )
      pre_shuffle = people_secretsantas.map { |p| p.person_id }
      allocation = SantaAllocation.new(people_secretsantas)
      allocation.gift_recipients = pre_shuffle
      expect(allocation.generate).to be_falsey
      expect(allocation.error_message).to include('Failed to allocate everyone to a Secret Santa')
    end
  end
end
