class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :poster
      t.text :content
      t.references :channel

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
