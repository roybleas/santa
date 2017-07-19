# though classes not normally in a helper it is only used
# to simplify view logic

class Setpath
   delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(current_year)
    @current_year = current_year
  end

  def for_year(this_year)
    return url_helpers.root_path if @current_year == this_year
    url_helpers.people_secretsanta_path(this_year)
  end
end
