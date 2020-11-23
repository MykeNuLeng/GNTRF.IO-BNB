require "sinatra/base"

class Controller < Sinatra::Base
  enable :sessions

  get '/' do
    erb(:home)
  end

  # test, remove later 
  get '/logged-in-test' do
    session[:user] = true
    erb(:home)
  end

  get '/listings' do
    @listings = User.all_spaces
    erb(:listings)
  end
end