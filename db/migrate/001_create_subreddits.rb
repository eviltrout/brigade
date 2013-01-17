class CreateSubreddits < ActiveRecord::Migration
  def change
    create_table :subreddits do |t|
      t.string :name, null: false
      t.timestamp :last_crawled_at
      t.timestamps
    end

    add_index :subreddits, :name, unique: true
  end
end
