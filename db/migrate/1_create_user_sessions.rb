class CreateUserSessions < ActiveRecord::Migration[5.2]
    def change
      create_table :sessions do |t|
        t.column :account, :string, :limit => 128
        t.column :token, :string, :limit => 128
        t.timestamps
      end
      add_index :sessions, [:account, :token]
    end
  end
  