class AddMerchantIdToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_reference :coupons, :merchant, index: true, foreign_key: true
  end
end
