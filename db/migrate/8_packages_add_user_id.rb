class PackagesAddUserId < ActiveRecord::Migration[5.2]
    def change
        add_column :packages, :user_id, :integer
    end
end