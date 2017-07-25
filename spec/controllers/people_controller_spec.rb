require 'rails_helper'

RSpec.describe PeopleController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http not found" do
      get :show, id: 1
      expect(response).to have_http_status(:not_found)
    end

    it "returns http success" do
      ps = FactoryGirl.create(:people_secretsanta)
      get :show, id: ps.id
      expect(response).to have_http_status(:success)
    end
  end

end
