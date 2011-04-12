require 'ostruct'

class Channel < ActiveRecord::Base
    validates_presence_of :name
    has_many :messages, :dependent => :destroy

    has_many :channelconfigs
    has_many :users, :through => :channelconfigs

    def num_messages
        Message.count(:conditions => "channel_id = #{self.id}")
    end

    def self.group messages
        return [] if messages.nil?
        message_groups = []
        while messages.length > 0
            message = messages.pop
            group = OpenStruct.new
            group.poster = message.poster
            group.date = message.pretty_updated_at
            group.messages = [message]
            while messages.length > 0 and messages.last.poster == group.poster
                group.messages << messages.pop
            end
            message_groups << group
        end
        return message_groups
    end

    def get_page_in_groups(branch_id=nil, from_date=nil)
        pagesize = 50

        date = nil
        date = Time.at(from_date.to_i) if from_date

        page = get_page(branch_id, pagesize, date)

        message_groups = Channel.group page

        return message_groups
    end

    def get_page branch_id=nil, pagesize=50, from_date=nil
        page = []
        if from_date
            page = self.messages.where(:branch_id => branch_id).where("created_at < ?", from_date).limit(pagesize).order("created_at DESC").all
        else
            page = self.messages.where(:branch_id => branch_id).limit(pagesize).order("created_at DESC").all
        end

        return page
    end

    def branch_ids
        arr = Message.select("DISTINCT(branch_id)").map(&:branch_id)
        return arr
    end

    def latest_for_branch(in_branch_id)
        if in_branch_id
            return Message.where("branch_id = ?", in_branch_id).last
        else
            return Message.where("channel_id = ? AND branch_id IS NULL", self.id).last
        end
    end

    def top_active_branches
        Message.where("created_at > ?", Time.now - (24 * 50 * 60)).select("DISTINCT(branch_id)").map(&:branch_id)
    end

    def parents_for_branch(in_branch_id)
        parents = []
        root_msg = Message.find(in_branch_id)
        parent_bid = root_msg.branch_id
        while not parent_bid.nil?
            root_msg = Message.find(parent_bid)
            parents << root_msg.id
            parent_bid = root_msg.branch_id
        end
        return parents.compact
    end

    def first_message_for_branch in_branch_id
        return self.messages.where(:branch_id => in_branch_id).first
    end

    def child_branches_for_branch in_branch_id
        return self.messages.where(:branch_id => in_branch_id, :has_branch => true).order("id DESC").limit(5).all.reverse.map(&:id)
    end
end
