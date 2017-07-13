# Process of allocation
# 1) create an array of Santas and array of gift recipients
# 2) shuffle the gift recipients
# 3) Step through each santa and allocate the last gift recipient  if valid
# 4) If gift recipient is invalid for this Santa then store the invalid
#    recipient and try the next gift recipient till valid match found
# 5) Once a valid match is found get the next Santa and first try match
#    against the last stored gift recipient that have been skipped over
# 6) Once all the potential gift recipients have been exhausted then
#    go back and find valid matches from the stored recipients.
# 7) If at the end of the allocation there are gift recipients left over then
#    assume the allocation failed.


class SantaAllocation
  attr_reader   :santas, :error_message
  attr_accessor :gift_recipients

  def initialize(people_secretsantas)
    @santas = []
    @gift_recipients = []
    people_secretsantas.each do |p|
      @santas<< SecretSanta.new(p)
      @gift_recipients << p.person_id
    end
    @gift_recipients.shuffle!
  end

  def generate

    gift_recipient = @gift_recipients.pop
    store = []

    @santas.each do |s|
      break if gift_recipient.nil?

      while s.santa_id.nil?

        if s.valid?(gift_recipient)
          s.santa_id = gift_recipient
          if store.empty?
            gift_recipient = @gift_recipients.pop
          else
            gift_recipient = store.pop
          end
        else
          store.push(gift_recipient)

          if !@gift_recipients.empty?
            gift_recipient = @gift_recipients.pop
          else
            valid_recipients = store.select { |recipient| s.valid?(recipient) }

            if valid_recipients.empty?
              gift_recipient = nil
            else
              gift_recipient = valid_recipients.first
              store.delete(valid_recipients.first)
            end
          end
        end
        break if gift_recipient.nil?
      end
    end
    if !@gift_recipients.empty? || !store.empty?
      @error_message = "Failed to allocate everyone to a Secret Santa"
      return false
    end
    return true
  end
end
