class Hint < ActiveRecord::Base
  set_table_name "hint"
  set_primary_key "hint_id"
  belongs_to :item
end
