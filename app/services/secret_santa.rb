class SecretSanta
  attr_accessor :santa_id
  attr_reader   :id

  def initialize( person_secretsanta)
    @id = person_secretsanta.id

    @invalid_ids = [ person_secretsanta.person_id ]
    @invalid_ids << person_secretsanta.partner_id unless person_secretsanta.partner_id.nil?
    @invalid_ids << person_secretsanta.previous_santa_id unless person_secretsanta.previous_santa_id.nil?
  end

  def valid?(gift_recipient_id)
    return false if gift_recipient_id.nil?
    !@invalid_ids.include?(gift_recipient_id)
  end
end
