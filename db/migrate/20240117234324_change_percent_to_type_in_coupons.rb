class ChangePercentToTypeInCoupons < ActiveRecord::Migration[7.0]
  def change
    rename_column :coupons, :percent, :discount_type
  end
end
