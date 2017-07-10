require 'csv'
class ImportParticipants
  attr_reader :error_message, :participants

  PARTICIPANT_NAME = 0
  PARTICIPANT_EMAIL = 1
  PARTNER_NAME = 2
  PARTNER_EMAIL = 3

  def initialize(file_path)
    @file_path = file_path
    @participants = []
  end

  def extract?
    begin

      CSV.foreach(@file_path) do |row|
        case row.size
        when 2
          participant = create_participant(row[PARTICIPANT_NAME],row[PARTICIPANT_EMAIL])
          return false if participant.invalid?
        when 4
          participant = create_participant(row[PARTICIPANT_NAME],row[PARTICIPANT_EMAIL])
          return false if participant.invalid?
          partner = create_participant(row[PARTNER_NAME],row[PARTNER_EMAIL])
          return false if partner.invalid?
          participant.partner = partner.name
          partner.partner = participant.name
        else
          @error_message = "Invalid value in Row: #{row}"
          return false
        end
      end

      true
    rescue => e
       @error_message = e.message

       false
    end
  end

private

  def create_participant(name,email)
    participant = Participant.new(name, email)

    if participant.invalid?
      @error_message = "Invalid participant #{name} , #{email}"
    else
      # verify not already in use
      if  not @participants.select{ |p| p.name == name.strip }.empty?
         @error_message = "Participant #{name} appears more than once"
         participant.duplicate_name = true
      else
        @participants << participant
      end
    end
    return participant
  end
end
