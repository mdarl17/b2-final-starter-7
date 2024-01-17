class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.integer :percentage_discount

      t.timestamps

      t.index :code, unique: true
    end
  end
end
