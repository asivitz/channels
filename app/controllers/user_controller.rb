class UserController < ApplicationController
    before_filter :login_required, :only=>['welcome', 'change_password']

    def register
        if request.post?  
            @user = User.new(params[:user])
            if @user.save
                session[:user] = User.authenticate(@user.alias, @user.password)
                flash[:message] = "Signup successful"
                redirect_to :action => "welcome"          
            else
                flash[:warning] = "Signup unsuccessful"
            end
        else
            @user = User.new
        end
    end

    def login
        if request.post?
            if session[:user] = User.authenticate(params[:user][:alias], params[:user][:password])
                flash[:message]  = "Login successful"
                redirect_to_stored
            else
                flash[:warning] = "Login unsuccessful"
            end
        end
    end

    def logout
        session[:user] = nil
        flash[:message] = 'Logged out'
        redirect_to :action => 'login'
    end

    def change_password
        @user=session[:user]
        if request.post?
            @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
            if @user.save
                flash[:message]="Password Changed"
            end
        end
    end

    def welcome
    end
end
