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

post '/signup' do
	@new_user = User.create(fname: params[:fname], lname: params[:lname], username: params[:username], email: params[:email], password: params[:password], gender: params[:gender], birthday: params[:birthday], country: params[:country], city: params[:city])
	puts @new_user
	redirect "/"
end

get '/profile' do

	@currentUser = User.find(session[:user_id])
	@title = @currentUser.fname
	erb :profile
end

get '/account' do
	@title = "Account"
	erb :account
end

get '/postfeed' do
	@title = "Feed"
end

# post for home login
post '/login' do
	puts "my params are" + params.inspect
	@user = User.where(username: params[:username]).first
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "You've been signed in successfully."
		redirect "/profile"
	else
		flash[:alert] = "There was a problem signing you in."
	end
	redirect '/home'
end



