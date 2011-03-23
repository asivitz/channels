require 'rubygems'
require 'sanitize'

class MessagesController < ApplicationController
    before_filter :login_required

    def create
        @channel = Channel.find(params[:channel_id])
        @branch = Branch.find(params[:message][:branch_id])

        if not @channel.users.include? @user
            flash[:warning] = 'You are not a member of this channel.'
            redirect_to :controller => "channels", :action => "index"
        end
        @message = @branch.messages.build(params[:message])
        @message.content = Sanitize.clean(@message.content, :elements => %w[abbr b br cite code em i pre q small strike strong sup sub u])
        @message.content.gsub!("\n","<br/>")
        if @message.content.length > 0
            @message.poster = @user.alias
            @message.channel = @channel
            @message.save
        else
            @message = nil
        end
        #redirect_to @channel

        #render :text => "#{@message.to_json}"
    end

    def destroy
        @channel = Channel.find(params[:channel_id])
        @message = @channel.messages.find(params[:id])
        if @message.poster == @user.alias
            @message.destroy
        end
    end
end
