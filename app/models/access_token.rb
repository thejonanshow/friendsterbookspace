class AccessToken < ApplicationRecord
  belongs_to :user

  def self.create_from_amazon(code:, user:)
    existing = AccessToken.find_by(provider: "amazon", user: user)
    return existing if existing && existing.valid_token?

    token_response = Clients::Amazon.fetch_token(code)

    if existing
      update_from_response(existing_token: existing, response: token_response)
    else
      AccessToken.create(
        provider: "amazon",
        token: token_response["access_token"],
        refresh_token: token_response["refresh_token"],
        expires_at: DateTime.now + token_response["expires_in"].to_i.seconds,
        user: user
      )
    end
  end

  def self.update_from_response(existing_token:, response:)
    existing_token.update(
      token: response["access_token"],
      refresh_token: response["refresh_token"],
      expires_at: DateTime.now + response["expires_in"].to_i.seconds
    )
  end

  def expired?
    DateTime.now > expires_at
  end

  def valid_token?
    !expired?
  end

  def refresh
    refresh_response = Clients::Amazon.refresh_token(refresh_token)
    AccessToken.update_from_response(existing_token: self, response: refresh_response)
  end
end
