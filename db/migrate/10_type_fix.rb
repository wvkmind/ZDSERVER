class TypeFix < ActiveRecord::Migration[5.2]
    def change
        remove_column :users, :tilizhi
        remove_column :users, :exp
        remove_column :users, :exp_rate
        remove_column :users, :phy_str_rate
        remove_column :users, :tra_rate

        add_column :users, :tra_rate, :float, default: 0
        add_column :users, :phy_str_rate, :float, default: 0
        add_column :users, :exp_rate, :float, default: 0
        add_column :users, :tilizhi, :float, default: 100
        add_column :users, :exp, :float, default: 0
    end
end