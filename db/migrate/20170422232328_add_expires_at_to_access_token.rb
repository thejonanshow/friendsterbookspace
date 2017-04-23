class AddExpiresAtToAccessToken < ActiveRecord::Migration[5.0]
  def change
    add_column :access_tokens, :expires_at, :datetime, null: false
  end
end
