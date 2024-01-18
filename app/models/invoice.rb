class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  belongs_to :coupon, optional: :true
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  belongs_to :coupon, optional: true

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discount_revenue 
    if Coupon.count > 0
      high_dollar = Coupon.where("status = 1 AND discount_type = 0").order("coupons.amount DESC").limit(1).first.amount
      high_percent = Coupon.where("status = 1 AND discount_type = 1").order("coupons.amount DESC").limit(1).first.amount
      
      self.total_revenue * (1 - (high_percent.to_f/100))
    end
  end
end
