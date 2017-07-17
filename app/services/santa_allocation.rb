# Process of allocation
#
# 1) Create an array of Santas and array of gift recipients
# 2) Shuffle the gift recipients
# 3) Step through each Santa and gift recipient and comapre to see if valid
# 4) If invalid - step through rest of gift recipients to find a valid match
# 5) If match found swap invalid gift recipient with valid one
# 6) If no more gift recipients then go back to the beginning and step through
# 7) If both earlier and current are matches swap
# 8) If run out of gift recipients assume cannot be a valid alloction of Santas
#    to participants

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

    gr_index = 0

    @santas.each do |s|
      # 3) Step through each Santa and gift recipient and comapre to see if valid
      if s.valid?(@gift_recipients[gr_index])
        gr_index += 1
      else
        # 4) If invalid - step through rest of gift recipients to find a valid match
        (gr_index + 1...@gift_recipients.size).each do |gr_idx_2|
          if s.valid?(@gift_recipients[gr_idx_2])
            # 5) If match found swap invalid gift recipient with valid one
            @gift_recipients[gr_index], @gift_recipients[gr_idx_2] = @gift_recipients[gr_idx_2], @gift_recipients[gr_index]
            break
          end
        end
        if s.valid?(@gift_recipients[@santas.index(s)])
          gr_index += 1
        else
          # 6) If no more gift recipients then go back to the beginning and step through
          (0...gr_index).each do |gr_idx_3|
            if s.valid?(@gift_recipients[gr_idx_3]) && @santas[gr_idx_3].valid?(@gift_recipients[gr_index])
              # 7) If both earlier and current are matches swap
              @gift_recipients[gr_index], @gift_recipients[gr_idx_3] = @gift_recipients[gr_idx_3], @gift_recipients[gr_index]
              break
            end
          end
          if s.valid?(@gift_recipients[@santas.index(s)])
            gr_index += 1
          else
            @error_message = "Failed to allocate everyone to a Secret Santa #{@santas.inspect} : #{@gift_recipients.inspect}"
            return false
          end
        end
      end
    end
    @santas.each_index { |idx| @santas[idx].santa_id = @gift_recipients[idx]}
    validate?
  end

  private

  def validate?
    @santas.each do |s|
      if !s.valid?(s.santa_id)
        @error_message = "Failed to allocate to a Secret Santa at id #{s.id}:  #{@santas.inspect}"
        return false
      end
    end
    true
  end

end
