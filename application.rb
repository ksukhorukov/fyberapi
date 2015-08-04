require 'sinatra'

get '/' do 
  erb :index
end

post '/offers' do 
  fyber = FyberAPI.new(params)
  fyber.request!
  if fyber.error?
      erb :error, :locals => { :error => fyber.error }
  else
      erb :offers, :locals => { :offers => fyber.offers } 
  end
end
