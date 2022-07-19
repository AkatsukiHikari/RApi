class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password
      t.string :password_digest
      t.string :email
      t.string :phone
      t.integer :sex
      t.text :address
      t.text :description
      t.timestamps
    end
  end
end
