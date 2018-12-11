class CreateUserUsers < ActiveRecord::Migration[5.2]
    def change
      create_table :users do |t|
        t.string :account, null:false, limit:64
        t.string :hashed_password, null:false, limit:128
        t.string :salt, null:false, limit:64
        t.integer :status, null:false, default:0
        t.timestamps
      end
      add_index :users, [:account], unique:true
    end
  end