class CreateLinkScores < ActiveRecord::Migration
  def change
    create_table :link_scores do |t|
      t.integer :link_id, null: false
      t.integer :ups, null: false
      t.integer :downs, null: false
      t.integer :score, null: false
      t.timestamps
    end

    add_index :link_scores, :link_id
  end
end
