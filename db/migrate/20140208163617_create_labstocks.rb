class CreateLabstocks < ActiveRecord::Migration
  def change
    create_table :labstocks do |t|
      t.integer :office_id
      t.integer :quantity
      t.integer :quantity_used, :default=>0
      t.string :status, :default=>"P"
      t.integer :lab_id

      t.timestamps
    end
  end
end
