require 'ostruct'

class Channel < ActiveRecord::Base
      validates_presence_of :name
      has_many :branches, :dependent => :destroy
      has_many :messages, :dependent => :destroy

      has_many :channelconfigs
      has_many :users, :through => :channelconfigs

      def num_messages
          Message.count(:conditions => "channel_id = #{self.id}")
      end
end
