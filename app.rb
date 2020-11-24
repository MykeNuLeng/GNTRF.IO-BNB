require "sinatra/base"
require_relative "./lib/space"

class Controller < Sinatra::Base
  enable :sessions

  get '/' do
    erb(:login_or_register)
  end

  # test, remove later 
  get '/logged-in-test' do
    session[:user] = true
    erb(:home)
  end

  get '/listings' do
    @listings = Space.all_spaces
    erb(:listings)
  end
end