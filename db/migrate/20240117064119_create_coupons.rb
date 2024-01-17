class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.integer :amount
      t.integer :percent
      t.integer :active
      
      t.timestamps

      t.index :code, unique: true
    end
  end
end
