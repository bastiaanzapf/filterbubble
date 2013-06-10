class Feed < ActiveRecord::Base
  set_primary_key "feed_id"
  set_table_name "feed"
  has_and_belongs_to_many :format
end
