class CreateFollows < ActiveRecord::Migration[6.0]
  def change
    create_table :follows do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: false }
      t.references :followed, null: false, foreign_key: { to_table: 'users' }, index: { unique: false }
      t.timestamps
    end
  end
end
