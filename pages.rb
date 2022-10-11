require 'webrick'
require 'sinatra'


get '/' do
  erb :layout
end

get '/hello/:name' do
  "Hello #{params['name']}!"
end

get '/hello/:name/:state' do
  "Hello #{params['name']} from #{params['state']}!"
end

get '/mortgage' do
  erb :mortgage, :locals => {
    :principal => params["principal"],
    :loan_term => params["loan_term"],
    :interest  => params["interest"],
    :income => params["income"],
    :monthly_debts => params["monthly_debts"],
    :down_payment  => params["down_payment"]
   }
end

get '/explode' do
  1/0
end