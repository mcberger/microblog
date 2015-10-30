class CreatePostsTable < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
  		t.integer :user_id
  		t.string :title
  		t.string :body
  		t.string :username
  		t.date :postdate
  	end
  end
end
