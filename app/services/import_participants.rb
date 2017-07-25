require 'csv'
class ImportParticipants
  attr_reader :error_message, :participants

  PARTICIPANT_NAME = 0
  PARTNER_NAME = 1


  def initialize(file_path)
    @file_path = file_path
    @participants = []
  end

  def extract?
    begin

      CSV.foreach(@file_path) do |row|
        row.each do |input|

          participants = input.nil? ? [] : input.split(/;/)

          case participants.size
          when 0
            # ignore
          when 1
            participant = create_participant(participants[PARTICIPANT_NAME])
            return false if participant.invalid?
          when 2
            participant = create_participant(participants[PARTICIPANT_NAME])
            return false if participant.invalid?
            partner = create_participant(participants[PARTNER_NAME])
            return false if partner.invalid?
            participant.partner = partner.name
            partner.partner = participant.name
          else
            @error_message = "Invalid value in Row: #{row}"
            return false
          end
        end
      end

      true
    rescue => e
       @error_message = e.message

       false
    end
  end


private

  def create_participant(name)
    participant = Participant.new(name)

    if participant.invalid?
      @error_message = "Invalid participant #{name}"
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
