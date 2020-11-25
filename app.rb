require "sinatra/base"
require 'sinatra/flash'
require_relative "./lib/space"
require_relative "./lib/user"
require_relative "./database_connection_setup"


class Controller < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  get '/' do
    @state = 'login'
    erb(:login_or_register)
  end

  post '/session/new' do
    session[:user] = User.authenticate(
      email: params[:email],
      password: params[:password]
    )

    if session[:user]
      redirect('/spaces')
    else
      flash[:notice] = "EMAIL OR PASSWORD INVALID"
      redirect('/')
    end
  end

  get '/users/new' do
    @state = 'register'
    erb(:login_or_register)
  end

  post '/users/new' do
    User.create(
      username: params[:username],
      email: params[:email],
      password: params[:password])

    redirect '/'
  end

  get '/spaces' do
    @spaces = Space.all
    p @spaces
    erb(:spaces)
  end
end