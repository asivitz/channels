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

        render :text => "#{@message.to_json}"
    end

    def destroy
        @channel = Channel.find(params[:channel_id])
        @message = @channel.messages.find(params[:id])
        if @message.poster == @user.alias
            @message.destroy
        end
    end
end
