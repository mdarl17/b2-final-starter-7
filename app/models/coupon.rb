class Coupon < ApplicationRecord 
  belongs_to :merchant
  has_many :invoices

  enum percent: { "unchecked": 0, "checked": 1 }
  enum active: { "inactive": 0, "active": 1 }
end