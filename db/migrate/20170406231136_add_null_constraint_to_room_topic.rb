class AddNullConstraintToRoomTopic < ActiveRecord::Migration[5.0]
  def change
    change_column_null :rooms, :topic, false
  end
end
