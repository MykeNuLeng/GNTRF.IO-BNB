require "sinatra/base"
require_relative "./lib/space"
require_relative "./lib/user"

class Controller < Sinatra::Base
  enable :sessions

  get '/' do
    @state = 'login'
    erb(:login_or_register)
  end

  # test, remove later 
  get '/logged-in-test' do
    session[:user] = true
    erb(:home)
  end

  get '/users/new' do
    @state = 'register'
    erb(:login_or_register)
  end

  post '/users/new' do
    User.create(email: params[:email], password: params[:password])
    redirect '/'
  end

  get '/listings' do
    @listings = Space.all_spaces
    erb(:listings)
  end
end