require 'rails_helper'

RSpec.feature "HomePages", type: :feature do
  scenario "redirects to load if no current santa lists loaded" do
    visit root_path
    expect(current_path).to eq load_path
  end


end
