class PeopleSecretsantasController < ApplicationController
  def show
    @year = params[:year].to_i

    if @year == PeopleSecretsantas.maximum('year')
      redirect_to archives_path
      return
    end

    @people_secretsantas = PeopleSecretsantas.include_people.
      include_partners.
      include_santas.
      include_previous_santas.
      by_year(@year).order("people.name")

    if @people_secretsantas.count == 0
      redirect_to archives_path
      return
    end

  end

  def destroy
    current_year = PeopleSecretsantas.maximum('year')
    this_year = params[:year].to_i

    deleted_count = PeopleSecretsantas.by_year(this_year).delete_all
    non_participants = Person.non_participants.all
    if !non_participants.nil?
      non_participants_index = non_participants.to_a.map{|p| p.id }
      Person.delete(non_participants_index)
    end
    flash[:success] = "Deleted all #{deleted_count} participants for year #{this_year}."

    if current_year == this_year
      redirect_to root_path
    else
      redirect_to archives_path
    end
  end

 end
