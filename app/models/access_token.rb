class AccessToken < ApplicationRecord
  belongs_to :user

  def self.create_from_amazon(code:, user:)
    existing = AccessToken.find_by(provider: "amazon", user: user)
    return existing if existing && existing.valid_token?

    token_response = Clients::Amazon.fetch_token(code)

    if existing
      existing.update(
        token: token_response["access_token"],
        refresh_token: token_response["refresh_token"],
        expires_at: DateTime.now + token_response["expires_in"].to_i.seconds
      )
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

  def expired?
    DateTime.now > expires_at
  end

  def valid_token?
    !expired?
  end

  def refresh
    Clients::Amazon.refresh_token(self)
  end
end
