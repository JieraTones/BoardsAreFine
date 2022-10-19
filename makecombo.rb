require 'webrick'
require 'sinatra'
require_relative 'lib/board_games'

get '/about' do
  erb :about, :layout => false
end

get '/' do
  erb :layout, :locals => {
    :site_name => params["site_name"],
    :board_numbers => params["board_numbers"],
    :submit => params["submit"],
    :destination_uid  => params["destination_uid"]
   }
end

# :layout => false, 
# tells sinatra to ignore the layout file
# layout is pulled in to all pages by default