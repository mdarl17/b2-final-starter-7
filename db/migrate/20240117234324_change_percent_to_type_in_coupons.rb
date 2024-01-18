class ChangePercentToTypeInCoupons < ActiveRecord::Migration[7.0]
  def change
    rename_column :coupons, :percent, :discount_type
    rename_column :coupons, :active, :status
    change_column :coupons, :status, :integer, :default => 1
  end
end
