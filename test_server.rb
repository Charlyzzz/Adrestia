require 'sinatra'
require 'net/http'

def fibo(n)
  return 1 if n == 1
  return 1 if n == 2
  fibo(n-1) + fibo(n-2)
end

get '/ping' do
   'pong!'
end

get '/fibo' do
   fibo(params['n'].to_i).to_s
end

get '/hit' do
  Net::HTTP.get('google.com', '/')
end
