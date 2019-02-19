class ColumnsFix < ActiveRecord::Migration[5.2]
    def change
        remove_column :users, :package_id
        remove_column :users, :tilizhi
        remove_column :users, :exp
        add_column :users, :tilizhi, :integer , default: 100
        add_column :users, :exp, :integer, default: 0
    end
end