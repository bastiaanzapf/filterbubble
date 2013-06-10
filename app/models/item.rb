class Item < ActiveRecord::Base
  set_table_name "item"
  set_primary_key "item_id"
  belongs_to :feed
end
