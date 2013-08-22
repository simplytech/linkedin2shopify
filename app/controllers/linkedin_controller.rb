class LinkedinController < ApplicationController

  @@linkedin_api_key = ENV['LINKEDIN_API_KEY']
  @@linkedin_secret  = ENV['LINKEDIN_SECRET']
  
  def index
    @my_var = 'LinkedIn #index'
    # get your api keys at https://www.linkedin.com/secure/developer
    client = LinkedIn::Client.new(@@linkedin_api_key, @@linkedin_secret)
    request_token = client.request_token(:oauth_callback => "http://#{request.host_with_port}/auth/linkedin/callback")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret

    redirect_to client.request_token.authorize_url

  end

  def callback
    client = LinkedIn::Client.new(@@linkedin_api_key, @@linkedin_secret)
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      client.authorize_from_access(session[:atoken], session[:asecret])
    end
    @my_var = 'LinkedIn #callback'
    @profile = client.profile
    @connections = client.connections
    @client = client
    # debugger
  end

end
