require 'webrick'
require 'sinatra'

get '/' do
  erb :layout, :locals => {
    :site_name => params["site_name"],
    :board_numbers => params["board_numbers"],
    :destination_uid  => params["destination_uid"]
   }
end
