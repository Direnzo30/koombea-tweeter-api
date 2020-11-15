class CreateTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tweets do |t|
      t.references :user, foreign_key: true
      t.string :content, null: false, limit: 280
      t.timestamps
    end
  end
end
