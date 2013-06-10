class Format < ActiveRecord::Base
  set_table_name "format"
  set_primary_key "format_id"
  has_and_belongs_to_many :feed
end
