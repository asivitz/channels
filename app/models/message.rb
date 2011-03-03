class Message < ActiveRecord::Base
    validates_presence_of :poster, :content
    belongs_to :channel

    def marked_up_content
        msg = self.content
        msg = CGI::escapeHTML(msg)
        matches = msg.scan(/https?:\/\/\S+/)
        matches.uniq.each do |word|
            msg.gsub!(word, "<a href=\\\"#{word}\\\">#{word}</a>")
        end
        msg
    end

    def pretty_updated_at
        return self.updated_at.localtime.strftime("%b %e %l:%M%p")
    end

    def to_json
         "{\"id\":#{self.id},\"name\":\"#{self.poster}\",\"date\":\"#{self.pretty_updated_at}\",\"content\":\"#{self.marked_up_content}\"}"
    end
end
