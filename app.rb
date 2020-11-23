require "sinatra"

class Controller < Sinatra::Base
  get '/' do
    "Hello world"
  end
end