class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_merchant_revenue(merchant)
    this_merchant(merchant).sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def this_merchant(merchant)
    self.invoice_items.joins(:item).where("items.merchant_id = #{merchant.id}")
  end
end
