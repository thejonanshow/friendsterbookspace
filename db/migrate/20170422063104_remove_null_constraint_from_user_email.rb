class RemoveNullConstraintFromUserEmail < ActiveRecord::Migration[5.0]
  def change
    change_column_null :users, :email, true
  end
end
