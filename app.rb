require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require 'rack-flash'
require './models'

enable :sessions
use Rack::Flash, :sweep =>true

set :database, "sqlite3:Micrapost_db.sqlite3"

get '/' do 
	@title = 'Home'
	erb :home
end

get '/signup' do
	@title = "Sign Up"
	erb :signup
end

get '/profile' do
	@title = "@user"
	erb :profile
end

get '/account' do
	@title = "Account"
	erb :account
end

get '/postfeed' do
	@title = "Feed"
end