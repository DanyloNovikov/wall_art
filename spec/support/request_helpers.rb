# frozen_string_literal: true

module RequestHelpers
  def json
    JSON.parse(response.body)
  end

  def jwt_token(admin)
    JWT.encode(
      { sub: admin.id, jti: admin.jti },
      Rails.application.credentials.secret_key_base, 'HS256'
    )
  end
end
