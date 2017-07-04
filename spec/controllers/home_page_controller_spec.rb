require 'rails_helper'

RSpec.describe HomePageController, type: :controller do

  describe "GET #home" do
    it "returns http success when a person secresanta is loaded" do
      person_santa = FactoryGirl.create(:people_secretsanta)
      get :home
      expect(response).to have_http_status(:success)
    end
    it "redirects to load when santa list empty" do
      get :home
      expect(response).to have_http_status(:redirect)
    end
  end
  describe "GET #load" do
    it "returns http success" do
      get :load
      expect(response).to have_http_status(:success)
    end
  end

end
