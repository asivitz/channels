class Channel < ActiveRecord::Base
      validates_presence_of :name
      has_many :messages, :dependent => :destroy
      has_and_belongs_to_many :users

      def num_messages
          Message.count(:conditions => "channel_id = #{self.id}")
      end
end
