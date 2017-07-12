class HomePageController < ApplicationController

  def home
    @year = PeopleSecretsantas.maximum('year')
    if @year.nil?
      redirect_to load_url
    else
      @people_secretsantas = PeopleSecretsantas.include_people.
        include_partners.
        include_santas.
        include_previous_santas.
        by_year(@year).order("people.name")
    end
  end

  def load
    @this_year = PeopleSecretsantas.maximum('year')
    @this_year = Date.today.year if @this_year.nil?
  end

  def import

    if  params[:file].nil?
      redirect_to load_path
      return
    end

    import = ImportParticipants.new(params[:file].path)
    if import.extract?
      # save new and updated people records
      Person.transaction do
        import.participants.each{ |p| p.person.save!}
      end

      santalist = SantaList.new(params[:currentyear], import.participants)
      PeopleSecretsantas.transaction do
        santalist.add_people_to_list
        santalist.update_with_previous_santas
      end

      redirect_to root_path
    else
      flash[:warning] = import.error_message
      redirect_to load_path
    end

  end

end
