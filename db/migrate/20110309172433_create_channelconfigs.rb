class CreateChannelconfigs < ActiveRecord::Migration
  def self.up
    create_table :channelconfigs do |t|
        t.integer :channel_id
        t.integer :user_id

        t.datetime :last_checked
    end
  end

  def self.down
    drop_table :channelconfigs
  end
end
