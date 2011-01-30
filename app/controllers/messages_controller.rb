class MessagesController < ApplicationController
    def create
        @channel = Channel.find(params[:channel_id])
        @message = @channel.messages.build(params[:message])
        @message.save
        redirect_to @channel
    end
end
