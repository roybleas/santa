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
    year = params[:year].to_i
    deleted_count = PeopleSecretsantas.by_year(year).delete_all
    flash[:success] = "Deleted all #{deleted_count} participants for year #{year}."
    redirect_to archives_path
  end

 end
