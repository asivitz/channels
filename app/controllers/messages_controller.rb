class MessagesController < ApplicationController
    before_filter :login_required

    def create
        @channel = Channel.find(params[:channel_id])
        @message = @channel.messages.build(params[:message])
        @message.poster = @user.alias
        @message.save
        redirect_to @channel
    end
end
