class Message < ActiveRecord::Base
    validates_presence_of :poster, :content
    belongs_to :channel
end
