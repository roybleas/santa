require 'rails_helper'


RSpec.describe "participant" do

  let(:new_person_name) {"A new person"}

  it "creates a new person" do
    p = Participant.new(new_person_name,"b@c.d")
    expect(p.person.name).to eq new_person_name
  end
  it "finds an existing person" do
    current_person = FactoryGirl.create(:person)
    p = Participant.new(current_person.name,"b@c.d")
    expect(p.person).to eq current_person
  end
  it "responds to name" do
    p = Participant.new(new_person_name,"b@c.d")
    expect(p).to respond_to(:name)
    expect(p.name).to eq new_person_name
  end
  it "tries to use an invalid person" do
    new_person_name = ""
    p = Participant.new(new_person_name,"b@c.d")
    expect(p.invalid?).to be_truthy
  end
  it " has a duplicate name" do
    p = Participant.new(new_person_name,"b@c.d")
    expect(p.invalid?).to be_falsey
    p.duplicate_name = true
    expect(p.invalid?).to be_truthy
  end
  it "has a partner" do
    p = Participant.new(new_person_name,"b@c.d")
    expect(p.has_partner?).to be_falsey
    p.partner = "Partner name"
    expect(p.has_partner?).to be_truthy
  end

end
