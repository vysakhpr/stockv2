class CreateLabs < ActiveRecord::Migration
  def change
    create_table :labs do |t|
      t.string :name
      t.string :username
      t.string :password_digest
      t.integer :department_id

      t.timestamps
    end
  end
end
