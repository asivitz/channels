class Message < ActiveRecord::Base
    validates_presence_of :poster, :content
    belongs_to :branch
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

    def make_branch
        new_branch = Branch.new
        new_branch.channel = self.channel
        new_branch.parent_branch_id = self.branch.id
        new_branch.root_message_id = self.id

        return new_branch
    end

    def child_branches
        return Branch.where(:root_message_id => self.id)
    end
end
