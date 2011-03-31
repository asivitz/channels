require 'ostruct'

class Channel < ActiveRecord::Base
    validates_presence_of :name
    has_many :messages, :dependent => :destroy

    has_many :channelconfigs
    has_many :users, :through => :channelconfigs

    def num_messages
        Message.count(:conditions => "channel_id = #{self.id}")
    end

    def get_page_in_groups(branch_id=nil, from_date=nil)
        pagesize = 50

        date = nil
        date = Time.at(from_date.to_i) if from_date

        page = get_page(branch_id, pagesize, date)

        message_groups = []
        while page.length > 0
            message = page.pop
            group = OpenStruct.new
            group.poster = message.poster
            group.date = message.pretty_updated_at
            group.messages = [message]
            while page.length > 0 and page.last.poster == group.poster
                group.messages << page.pop
            end
            message_groups << group
        end
        return message_groups
    end

    def get_page branch_id=nil, pagesize=50, from_date=nil
        page = []
        if from_date
            page = self.messages.where(:branch_id => branch_id).where("created_at < ?", from_date).limit(pagesize).order("created_at DESC").all
        else
            page = self.messages.where(:branch_id => branch_id).limit(pagesize).order("created_at DESC").all
        end

        page.each do |msg|
            msg.branch_link = msg.id if msg.has_branch? # the unused branch id must be its own id
        end

        if page.size < pagesize and not branch_id.nil?
            root_message = Message.find(branch_id)
            root_message.branch_link = root_message.branch_id # the unused branch id must be it own branch
            page << root_message
            date = root_message.created_at
            page.concat self.get_page(root_message.branch_id, pagesize - page.size, date)
        end

        return page
    end

    def branch_ids
        arr = Message.select("DISTINCT(branch_id)").map(&:branch_id)
        return arr
    end
end
