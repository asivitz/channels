class Message < ActiveRecord::Base
    validates_presence_of :poster, :content
    belongs_to :channel

    def marked_up_content
        msg = self.content
        matches = msg.scan(/http:\/\/\S+/)
        matches.uniq.each do |word|
            msg.gsub!(word, "<a href=\"#{word}\">#{word}</a>")
        end
        msg
    end
end
