class Participant
  attr :person
  attr_accessor :partner
  attr_writer :duplicate_name

  def initialize(this_name, this_email)
    @person = Person.find_or_initialize_by(name: this_name.strip)
    @person.email = this_email.strip
    @duplicate_name = false
  end

  def invalid?
    return true if @person.invalid?
    return true if @duplicate_name
    return false
  end

  def has_partner?
    not @partner.nil?
  end

  def name
    @person.name
  end
end
