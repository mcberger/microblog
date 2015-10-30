class CreateUsersTable < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :fname
  		t.string :lname
  		t.string :email
  		t.string :city
  		t.string :country
  		t.date :birthday
  		t.timestamp :joindate
  		t.string :gender
  		t.string :username
  		t.string :password 
  	end
  end
end
