class Title < ActiveRecord::Base
  set_primary_key "title_id"
  belongs_to :item

end
