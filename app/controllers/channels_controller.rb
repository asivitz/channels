class ChannelsController < ApplicationController
    before_filter :login_required

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
    @channel = Channel.find(params[:id])
    @message = Message.new # to add a new message

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
    @channel = Channel.find(params[:id])
  end

  # POST /channels
  # POST /channels.xml
  def create
    @channel = Channel.new(params[:channel])
    @channel.users << @user

    respond_to do |format|
      if @channel.save
        flash[:notice] = 'Channel was successfully created.'
        format.html { redirect_to(@channel) }
        format.xml  { render :xml => @channel, :status => :created, :location => @channel }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @channel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /channels/1
  # PUT /channels/1.xml
  def update
    @channel = Channel.find(params[:id])

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
    @channel = Channel.find(params[:id])
    @channel.destroy

    respond_to do |format|
      format.html { redirect_to(channels_url) }
      format.xml  { head :ok }
    end
  end

  def add_user
      @channel = Channel.find(params[:channel][:id])
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
      @channel = Channel.find(params[:id])
      @channel.users.delete @user
      @channel.save
      redirect_to :action => "index"
  end
end
