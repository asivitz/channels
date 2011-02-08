class AddChannelsUsersJoinTable < ActiveRecord::Migration
  def self.up
      create_table :channels_users, :id => false do |t|
          t.integer :channel_id
          t.integer :user_id
      end
  end

  def self.down
      drop_table :channels_users
  end
end
