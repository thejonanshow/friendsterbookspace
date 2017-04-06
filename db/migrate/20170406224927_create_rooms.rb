class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms, id: :uuid do |t|
      t.string :slug
      t.string :topic

      t.timestamps
    end
  end
end
