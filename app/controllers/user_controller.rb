class UserController < ApplicationController
    before_filter :login_required, :only=>['welcome', 'change_password']

    def register
        if request.post?  
            code = params[:register_code]
            regcodeattempt = Digest::SHA1.hexdigest(code)
            realsha1 = "120f96256585144f7d145089b28f555739fe047e"

            @user = User.new(params[:user])

            if (regcodeattempt != realsha1)
                flash[:warning] = "Incorrect registration code"
                return
            end

            if @user.save
                User.authenticate(@user.alias, @user.password)
                session[:user_id]  = @user.id
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
            if session[:user_id] = User.authenticate(params[:user][:alias], params[:user][:password]).id
                flash[:message]  = "Login successful"
                redirect_to_stored
            else
                flash[:warning] = "Login unsuccessful"
            end
        end
    end

    def logout
        session[:user_id] = nil
        flash[:message] = 'Logged out'
        redirect_to :action => 'login'
    end

    def change_password
        uid = session[:user_id]
        @user = User.where(:id => uid).first
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
