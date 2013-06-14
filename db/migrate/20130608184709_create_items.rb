class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.int :item_id
      t.int :feed_id
      t.string :link
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
