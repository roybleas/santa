class SecretSanta
  attr_accessor :santa_id
  attr_reader   :id

  def initialize( person_secresanta)
    @id = person_secresanta.id
    @invalid_ids = []
    @invalid_ids << person_secresanta.person_id
    @invalid_ids << person_secresanta.partner_id unless person_secresanta.partner_id.nil?
    @invalid_ids << person_secresanta.previous_santa_id unless person_secresanta.previous_santa_id.nil?
  end

  def valid?(gift_recipient_id)
    return false if gift_recipient_id.nil?
    !@invalid_ids.include?(gift_recipient_id)
  end
end
