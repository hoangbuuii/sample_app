class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_column :users, :password_digest, :string
    add_column :users, :remember_digest, :string
    add_column :users, :is_admin, :boolean, default: false

    add_column :users, :activation_digest, :string
    add_column :users, :activated, :boolean
    add_column :users, :activated_at, :datetime

    add_column :users, :reset_digest, :string
    add_column :users, :reset_sent_at, :datetime

    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
    add_column :microposts, :picture, :string
  end
end
