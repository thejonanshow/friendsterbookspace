class User < ApplicationRecord
  has_many :messages
  has_many :chatrooms, through: :messages
  has_many :access_tokens

  def self.find_or_create_from_auth_hash(auth_hash)
    User.find_or_create_by(
      name: auth_hash[:info][:name],
      email: auth_hash[:info][:email]
    )
  end

  def channel
    "user_#{id}"
  end

  def first_name
    name.split.first
  end

  def admin?
    return unless ENV["ADMINS"]
    ENV["ADMINS"].split(",").include? email
  end

  def amazon_token?
    amazon_token.present?
  end

  def amazon_token
    access_tokens.where(provider: "amazon").first
  end

  def is_alexa?
    name == "Alexa"
  end

  def is_not_alexa?
    !is_alexa?
  end
end
