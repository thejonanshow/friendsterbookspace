class AddUuidExtension < ActiveRecord::Migration[5.0]
  def change
    execute 'CREATE EXTENSION "uuid-ossp" SCHEMA public'
  end
end
