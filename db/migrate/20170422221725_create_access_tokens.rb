class CreateAccessTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :access_tokens, id: :uuid do |t|
      t.string :provider, null: false
      t.string :token, null: false
      t.uuid :user_id, null: false

      t.timestamps
    end
  end
end
