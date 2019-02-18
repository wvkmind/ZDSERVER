class Package < ActiveRecord::Base
    self.table_name = "packages"
	self.primary_key = "id"
    self.inheritance_column = '_type'
    belongs_to :user, class_name: "User", foreign_key: "package_id"
end