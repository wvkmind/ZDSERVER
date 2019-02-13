class Package < ActiveRecord::Base
    self.table_name = "packages"
	self.primary_key = "id"
    self.inheritance_column = '_type'
end