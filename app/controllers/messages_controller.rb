class MessagesController < ApplicationController
    before_filter :login_required

    def create
        @channel = Channel.find(params[:channel_id])
        if not @channel.users.include? @user
            flash[:warning] = 'You are not a member of this channel.'
            redirect_to :controller => "channels", :action => "index"
        end
        @message = @channel.messages.build(params[:message])
        @message.poster = @user.alias
        @message.save
        #redirect_to @channel

        render :text => "{\"id\":\"#{@message.id}\", \"time\":\"#{@message.pretty_updated_at}\"}"
    end
end
