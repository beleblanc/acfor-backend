module AuthToken
  #Encode the token
  
  def self.encode(payload, expiration = 24.hours.from_now)
    payload = payload.dup
    payload[:exp] = expiration.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token, leeway = nil)
    decoded = JWT.decode(token, Rails.application.secrets.secret_key_base, leeway: leeway)
    HashWithIndifferentAccess.new(decoded[0])
  rescue
    nil
  end
end
