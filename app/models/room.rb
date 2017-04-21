class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users, through: :messages
  validates :topic, presence: true, uniqueness: true, case_sensitive: false

  def self.default_room
    find_or_create_by(topic: "General", slug: "general")
  end
end
