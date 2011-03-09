class Message < ActiveRecord::Base
    validates_presence_of :poster, :content
    belongs_to :channel

    scope :since, lambda {|time| where("updated_at > ?", time)}

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
        return self.updated_at.localtime.strftime("%b %e %l:%M%p")
    end

    def to_json
        content = escape_quotes(self.marked_up_content)
         "{\"id\":#{self.id},\"name\":\"#{self.poster}\",\"date\":\"#{self.pretty_updated_at}\",\"content\":\"#{content}\"}"
    end
end
