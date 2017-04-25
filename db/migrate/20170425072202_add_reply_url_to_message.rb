class AddReplyUrlToMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :reply_url, :string
  end
end
