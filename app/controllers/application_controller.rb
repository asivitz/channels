# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  def login_required
      if session[:user_id]
          @user = current_user if @user.nil?
          return true if @user
      end
      flash[:warning]='Please login to continue'
      session[:return_to]=request.fullpath
      redirect_to :controller => "user", :action => "login"
      return false 
  end

  def member_required
      @user = current_user if @user.nil?
      @channel = Channel.find(params[:id])
      if @channel.users.include? @user
          return true
      end

      flash[:warning] = 'You are not a member of this channel.'
      redirect_to :controller => "channels", :action => "index"
      return false
  end

  def current_user
      uid = session[:user_id]
      User.find(uid)
  end

  def redirect_to_stored
      if return_to = session[:return_to]
          session[:return_to]=nil
          redirect_to(return_to)
      else
          redirect_to :controller=>'user', :action=>'welcome'
      end
  end
end
