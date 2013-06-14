class Item < ActiveRecord::Base
  set_table_name "item"
  set_primary_key "item_id"

  belongs_to :feed
  belongs_to :format
  belongs_to :item_category
  has_and_belongs_to_many :category
end
