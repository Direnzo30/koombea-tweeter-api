class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :username, null: false, :unique => true, index: { unique: true }
      t.string :email, null: false, :unique => true, index: { unique: true }
      t.string :password_digest, null: false
      t.string :authorization_token, :unique => true, index: { unique: false }
      t.datetime :token_lifetime
      t.timestamps
    end
  end
end
