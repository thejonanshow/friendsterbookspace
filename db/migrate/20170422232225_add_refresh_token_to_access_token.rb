class AddRefreshTokenToAccessToken < ActiveRecord::Migration[5.0]
  def change
    add_column :access_tokens, :refresh_token, :string, null: false
  end
end
