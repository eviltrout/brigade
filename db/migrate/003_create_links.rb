class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :submission_id, null: false
      t.string :url, null: false, limit: 1000
      t.integer :earliest_score 
      t.integer :latest_score
      t.timestamp :locked_at
      t.timestamp :last_crawled_at
      t.timestamps
    end

    add_index :links, :submission_id
  end
end
