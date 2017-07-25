module ShowMessage
  extend ActiveSupport::Concern

  def when_missing_santa_ids_show_message(this_year)
    if PeopleSecretsantas.by_year(this_year).where("santa_id is null").count > 0
      flash.now[:warning] = "Warning: Participants have not all been allocated to be a Secret Santa."
    end
  end

end
