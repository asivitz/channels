class Branch < ActiveRecord::Base
    belongs_to :channel
    has_many :messages, :dependent => :destroy

    def get_page from_date=nil
        pagesize = 20
        if from_date
            date = Time.at(from_date.to_i)
            page = self.messages.where("updated_at < ?", date).limit(pagesize).order("updated_at DESC").all.reverse
        else
            page = self.messages.limit(pagesize).order("updated_at DESC").all.reverse
        end

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

end
