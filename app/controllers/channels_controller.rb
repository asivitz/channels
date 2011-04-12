class ChannelsController < ApplicationController
    before_filter :login_required
    before_filter :member_required, :only => [:show, :update, :destroy, :add_user, :leave_channel, :get_updates, :get_message, :edit, :get_page, :create_branch]

  # GET /channels
  # GET /channels.xml
  def index
    @channels = Channel.all
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @channels }
    end
  end

  # GET /channels/1
  # GET /channels/1.xml
  def show
    @message = Message.new # to add a new message


    @channelconfig = @user.channelconfigs.where(:channel_id => @channel.id).first
    @previously_last_checked = @channelconfig.last_checked
    @previously_last_checked = Time.now if @previously_last_checked.nil?
    @channelconfig.last_checked = Time.now
    @channelconfig.save

    get_page

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @channel }
    end
  end

  # GET /channels/new
  # GET /channels/new.xml
  def new
    @channel = Channel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @channel }
    end
  end

  # GET /channels/1/edit
  def edit
  end

  # POST /channels
  # POST /channels.xml
  def create
    @channel = Channel.new(params[:channel])

    respond_to do |format|
      if @channel.save
          @channel.users << @user
          @channel.save
        flash[:notice] = 'Channel was successfully created.'
        format.html { redirect_to(@channel) }
        format.xml  { render :xml => @channel, :status => :created, :location => @channel }
      else
        flash[:warning] = 'Could not create channel'
        logger.debug @channel.errors.full_messages
        format.html { render :action => "new" }
        format.xml  { render :xml => @channel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /channels/1
  # PUT /channels/1.xml
  def update
    respond_to do |format|
      if @channel.update_attributes(params[:channel])
        flash[:notice] = 'Channel was successfully updated.'
        format.html { redirect_to(@channel) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @channel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1
  # DELETE /channels/1.xml
  def destroy
    @channel.destroy

    respond_to do |format|
      format.html { redirect_to(channels_url) }
      format.xml  { head :ok }
    end
  end

  def add_user
      toadd = User.find_by_alias(params[:user][:alias])
      if toadd.nil?
          flash[:warning] = "No such user to add"
      elsif @channel.users.include? toadd
          flash[:warning] = "User already a member of channel"
      else
          @channel.users << toadd
          @channel.save
      end
      redirect_to(@channel)
  end

  def leave_channel
      @channel.users.delete @user
      @channel.save
      redirect_to :action => "index"
  end

  def get_page
      @previously_last_checked = Time.now if @previously_last_checked.nil? # these messages shouldn't appear unread

      if params[:from_date]
          date = Time.at(params[:from_date].to_i)
          @message_groups = @channel.get_page_in_groups(params[:branch_id], date)
      else
          @message_groups = @channel.get_page_in_groups(params[:branch_id])
      end
  end

  def get_updates 
      previous_check = params[:previous_check]
      if previous_check
          prevtime = Time.at(previous_check.to_i)

          @branches = {}
          new_messages = Message.since(prevtime).all
          new_messages.each do |m|
              if @branches.has_key? m.branch_id
                  @branches[m.branch_id.to_i] << m
              else
                  @branches[m.branch_id.to_i] = [m]
              end
          end

          if not new_messages.empty?
              @channelconfig = Channelconfig.where("user_id = ? AND channel_id = ?", @user.id, @channel.id).first
              @channelconfig.last_checked = Time.now
              @channelconfig.save
          end
      end
  end
end
