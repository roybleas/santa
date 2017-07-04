class HomePageController < ApplicationController
  def home
    @year = PeopleSecretsantas.maximum('year')
    if @year.nil?
      redirect_to load_url
    else
    end
  end

  def load
  end

  def import
    redirect_to root_path
  end
end
