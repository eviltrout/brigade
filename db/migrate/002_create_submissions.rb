class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.string :reddit_id, null: false 
      t.integer :subreddit_id, null: false
      t.string :title, null: false, limit: 300
      t.string :permalink, null: false, limit: 500
      t.timestamp :submission_date, null: false
      t.timestamps
    end

    add_index :submissions, :reddit_id, unique: true
    add_index :submissions, :subreddit_id
  end
end
