class Message < ActiveRecord::Base
    validates_presence_of :poster, :content
    belongs_to :channel

    scope :since, lambda {|time| where("created_at > ?", time)}

    attr_accessor :branch_link

    def marked_up_content
        msg = self.content
        #msg = CGI::escapeHTML(msg)
        matches = msg.scan(/https?:\/\/\S+/)
        matches.uniq.each do |word|
            msg.gsub!(word, "<a href=\"#{word}\">#{word}</a>")
        end
        msg
    end

    def escape_quotes string
        string.gsub('"', '\"')
    end

    def pretty_updated_at
        return self.created_at.localtime.strftime("%b %e %l:%M%p")
    end

    def to_json
        content = escape_quotes(self.marked_up_content)
         "{\"id\":#{self.id},\"name\":\"#{self.poster}\",\"date\":\"#{self.pretty_updated_at}\",\"content\":\"#{content}\"}"
    end

    def branch_message
        raise "already branched" if has_branch?

        bud = Message.new
        bud.branch_id = self.id
        self.has_branch = true
        self.save
        return bud
    end

    def successor_for_branch in_branch_id
        if in_branch_id
            return Message.where("branch_id = ? AND created_at > ?", in_branch_id, self.created_at).first
        else
            return Message.where("channel_id = ? AND branch_id IS NULL AND created_at > ?", self.channel_id, self.created_at).first
        end
    end

    def summarize chars=15
        return self.content if self.content.length <= chars
        return self.content[0..chars-3] + "..."
    end
end
