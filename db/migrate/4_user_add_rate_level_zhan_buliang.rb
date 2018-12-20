class UserAddRateLevelZhanBuliang < ActiveRecord::Migration[5.2]
    def change
        add_column :users, :tra_rate, :integer #变身率
        add_column :users, :phy_str_rate, :integer #体力恢复率
        add_column :users, :exp_rate, :integer #经验获得率
        add_column :users, :level, :integer #等级
        add_column :users, :zhanyang, :integer #赞扬
        add_column :users, :buliang, :integer #不良
    end
end