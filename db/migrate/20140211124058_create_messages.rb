class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :lab_id
      t.string :message_type
      t.string :name
      t.integer :quantity,:default=>0
      t.string :sender
      t.integer :department_id

      t.timestamps
    end
  end
end
