class Coupon < ApplicationRecord 
  belongs_to :merchant
  has_many :invoices
  has_many :transactions, through: :invoices

  enum discount_type: { "dollar": 0, "percent": 1 }
  enum status: ["inactive", "active"]\

  def self.by_status(stat)
    self.where(status: stat)
  end

  def usage_count
    self.transactions
      .where("transactions.result > 0")
      .count
  end

  def pending_invoices?
    self.invoices.where("invoices.status = 1").count > 0
  end

end