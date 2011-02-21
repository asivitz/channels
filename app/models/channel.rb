require 'ostruct'

class Channel < ActiveRecord::Base
      validates_presence_of :name
      has_many :messages, :dependent => :destroy
      has_and_belongs_to_many :users

      def num_messages
          Message.count(:conditions => "channel_id = #{self.id}")
      end

      def grouped_messages #messages from same poster grouped together
          all = self.messages
          groups = []
          while all.length > 0
              message = all.pop
              group = OpenStruct.new
              group.poster = message.poster
              group.date = message.pretty_updated_at
              group.messages = [message]
              while all.length > 0 and all.last.poster == group.poster
                  group.messages << all.pop
              end
              groups << group
          end
          return groups
      end
end
