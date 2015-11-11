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
	#session.clear
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
	@user = @currentUser
	@top_three_posts = @user.posts.order(id: :desc).limit 3
	@title = @currentUser.fname
	erb :profile
end

get '/profiles/:id' do
	@currentUser = User.find(session[:user_id])
	@user = User.find(params[:id])
	@top_three_posts = @user.posts.order(id: :desc).limit 3
	@title = @currentUser.fname
	erb :profile
end

# get '/profiles/:id' do
# 	@currentUser =User.find(session[:us])
# 	@top_three_posts = @currentUser.posts.order(id: :desc).limit 3
# 	@title = @User.find(session[:user_id])
# 	erb :profile
# end

get '/users' do
	@users = User.all
	erb :users
end

post '/profile' do
	@currentUser = User.find(session[:user_id])
	@new_post = Post.create(title: params[:title], body: params[:body], user_id: @currentUser.id)
	redirect '/profile'
end

get '/account' do
	@currentUser = User.find(session[:user_id])
	@title = "Account"
	erb :account
end

post '/account' do
	@currentUser = User.find(session[:user_id])
	if @currentUser.update_attributes(params[:user])
		flash[:notice] = "Your account has been updated."
	else
		flash[:alert] = "There was a problem updating your account."
	end
	redirect "/profile"
end

delete '/account' do
	@currentUser = User.find(session[:user_id])
	@currentUser.destroy
	session.clear
	redirect "/"
end

get '/postfeed' do

	@currentUser = User.find(session[:user_id])
	@posts = Post.order(id: :desc)
	@title = "Feed"
	erb :postfeed
end

get '/posts' do

	@currentUser = User.find(session[:user_id])
	@title = "Posts"
	erb :posts
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
	redirect '/'
end

get '/signout' do
	session[:user_id] = nil
	flash[:notice] = "You have been successfully signed out."
	redirect '/'
end

post '/follow/:id' do
	@currentUser = User.find(session[:user_id])
	@user = User.find(params[:id])

	if @currentUser.followees.include? @user
		flash[:alert] = "You are already following " + @user.fname
	else
		@follow = Follow.create(follower_id: @currentUser.id, followee_id: @user.id)
		flash[:notice] = "You are now following " + @user.fname
	end
	redirect '/profile'
end

# def following
# 	Followership.where(:follower_id=>:self.id).not_blocked
# end

# post '/' do
# 	session.clear
# 	redirect '/'
# end

