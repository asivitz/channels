class Branch < ActiveRecord::Base
    belongs_to :channel
    has_many :messages, :dependent => :destroy

    def get_page_in_groups from_date=nil
        pagesize = 50

        date = nil
        date = Time.at(from_date.to_i) if from_date

        page = get_page(pagesize, date)

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

    def get_page pagesize, from_date=nil
        page = []
        if from_date
            page = self.messages.where("updated_at < ?", from_date).limit(pagesize).order("updated_at DESC").all
        else
            page = self.messages.limit(pagesize).order("updated_at DESC").all
        end

        if page.size < pagesize
            parent_branch = self.parent
            if parent_branch
                root_msg = self.root_message
                page << root_msg
                date = root_msg.updated_at
                page.concat parent_branch.get_page(pagesize - page.size, date)
            end
        end
        return page
    end

    def parent
        if not self.parent_branch_id.nil?
            return Branch.find(self.parent_branch_id)
        end
        return nil
    end

    def root_message
        if not self.root_message_id.nil?
            return Message.find(self.root_message_id)
        end
        return self.messages.first
    end

end
