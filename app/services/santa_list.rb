class SantaList
  def initialize(year,participants)
    @year = year.to_i
    @participants = participants
  end

  def add_people
    @participants.each do |p|
      this_partner = Person.find_by name: p.partner
      this_partner_id = this_partner.id unless this_partner.nil?
      PeopleSecretsantas.create(year: @year, person_id: p.person.id, partner_id: this_partner_id)
    end
  end

  def update_with_previous_santas
    previous_participants = PeopleSecretsantas.
        join_self_as_s2.
        where_this_year_and_s2_last_year(@year).
        selecting_this_year_id_and_last_year_santa_id.all

    previous_participants.each do |p|
      PeopleSecretsantas.update(p.id,  previous_santa_id: p.last_year_santa_id)
    end
  end
end
