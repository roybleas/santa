class PeopleController < ApplicationController
  def index
    @current_year = PeopleSecretsantas.maximum('year')
    @people = Person.joins(:people_secretsantas).includes(:people_secretsantas).order("people.name","people_secretsantas.year").all
  end

  def show
    @person = Person.find_by id: params[:id]
    if @person.nil?
      content_not_found
    else
      @current_year = PeopleSecretsantas.maximum('year')
      @people_secretsantas = PeopleSecretsantas.
        include_partners.
        include_santas.
        include_previous_santas.
        by_person(@person).order(year: :desc)
    end
  end
end
