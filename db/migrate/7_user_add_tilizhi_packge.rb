class UserAddTilizhiPackge < ActiveRecord::Migration[5.2]
    def change
        create_table :packages do |t|
            t.column :type, :integer
            t.column :item_id, :integer
            t.column :count, :integer
            t.timestamps
        end
        add_index :packages, [:type]
        add_index :packages, [:item_id]
        add_index :packages, [:type, :item_id]
        add_column :users, :tilizhi, :integer
        add_column :users, :package_id, :integer
        add_column :users, :exp, :integer
    end
end