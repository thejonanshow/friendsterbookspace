class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.references :user, foreign_key: true, index: true, type: :uuid
      t.references :room, foreign_key: true, index: true, type: :uuid

      t.timestamps
    end
  end
end
