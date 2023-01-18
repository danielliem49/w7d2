
class SessionsController < ApplicationController
    before_action :require_logged_out

    def new
        render :new
    end

    def create 
        user= User.find_by_credentials(params[:user][:username], params[:user][:password])

        if user
            # create s_t key in the session object, equal to users token
            session[:session_token] = user.reset_session_token!
            redirect_to users_url
        else
            # user is nil or not found
            render json: ["Invalid Credentials"]
        end
    end

    def destroy
        logout!
        redirect_to new_session_url # might as well take them to sign in
    end

end
