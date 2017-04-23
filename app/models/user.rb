class User < ApplicationRecord
  has_many :messages
  has_many :chatrooms, through: :messages
  has_many :access_tokens

  def self.find_or_create_from_auth_hash(auth_hash)
    User.create(
      name: auth_hash[:info][:name],
      email: auth_hash[:info][:email]
    )
  end
end
