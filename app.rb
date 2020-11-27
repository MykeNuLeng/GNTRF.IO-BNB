require "sinatra/base"
require 'sinatra/flash'
require_relative "./lib/space"
require_relative "./lib/user"
require_relative "./database_connection_setup"
require_relative "./lib/order"


class Controller < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  get '/' do
    redirect('/spaces') if session[:user]

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

  get '/sessions/end' do
    session.clear
    flash[:notice] = "YOU'VE LOGGED OFF"
    redirect '/'
  end

  get '/users/new' do
    @state = 'register'
    erb(:login_or_register)
  end

  post '/users/new' do
    user = User.create(
      username: params[:username],
      email: params[:email],
      password: params[:password])

    if user == false
      flash[:notice] = "INVALID FIELD ENTRY"
      redirect '/users/new'
    end  

    redirect '/'
  end

  get '/spaces' do
    @spaces = Space.all
    erb(:spaces)
  end

  get '/spaces/new' do
    redirect('/') unless session[:user]

    erb :'spaces/new'
  end

  post '/spaces/new' do
    Space.create(
      user_id: session[:user].user_id,
      price: params[:price].to_i * 100,
      headline: params[:headline],
      description: params[:description],
      image: params[:photo]
    )

    redirect('/spaces')
  end

  get '/spaces/:id/add-availability' do
    redirect('/') unless session[:user]

    "Hello Availability!"
  end

  get '/profile' do
    redirect('/') unless session[:user]

    @orders = Order.order_history_by_renter_id(user_id: session[:user].user_id)
    erb :'profile/bookings'
  end

  get '/profile/lettings' do
    redirect('/') unless session[:user]

    @lettings = Order.order_history_by_landlord_id(user_id: session[:user].user_id)
    erb :'profile/lettings'
  end

  get '/profile/spaces' do
    redirect('/') unless session[:user]

    @spaces = Space.all_by_user(user_id: session[:user].user_id)
    erb :'profile/spaces'
  end

  get '/profile/lettings/:id/reject' do
    Order.reject(order_id: params[:id])
    redirect '/profile/lettings'
  end

  get '/profile/lettings/:id/confirm' do
    Order.confirm(order_id: params[:id])
    redirect '/profile/lettings'
  end
end
