class JsonWebToken
  AUTH_SECRET = ENV.fetch("AUTH_SECRET")

  def self.encode(payload, exp = 1.week.from_now)
    payload[:exp] = exp.to_i

    JWT.encode(payload, AUTH_SECRET)
  end

  def self.decode(token)
    decoded = JWT.decode(token, AUTH_SECRET).first

    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
end
