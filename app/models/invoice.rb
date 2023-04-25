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

  def merchant_discount_table(merchant)
    merchant.invoice_items
      .joins(invoice:  {merchants: :bulk_discounts})
      .where("invoice_items.quantity >= bulk_discounts.threshold AND invoices.id = #{self.id}")
      .select("invoice_items.id, MAX(invoice_items.quantity * invoice_items.unit_price * (bulk_discounts.discount/100)) AS total_discount")
      .group("invoice_items.id")
  end

  def total_merchant_discount(merchant)
    discount = Merchant.from(merchant_discount_table(merchant), :discounts_table)
      .select("sum(discounts_table.total_discount) AS total_discount_sum")
      .to_a.first.total_discount_sum
    if !discount.nil?
      return discount
    else
      return 0
    end
  end

  def admin_discount_table
    invoice_items.joins(:bulk_discounts)
      .where("invoice_items.quantity >= bulk_discounts.threshold")
      .select("MAX(invoice_items.quantity * invoice_items.unit_price *  (bulk_discounts.discount / 100)) AS total_discount, invoice_items.id")
      .group("invoice_items.id")
  end

  def total_admin_discount
    discount = Invoice.from(admin_discount_table, :discounts_table)
      .select("SUM(discounts_table.total_discount) AS total_discount_sum")
      .to_a.first.total_discount_sum
    if !discount.nil?
      return discount
    else
      return 0
    end
  end

  def total_merchant_sum(merchant)
    total_merchant_revenue(merchant) - total_merchant_discount(merchant) 
  end

  def total_admin_sum
    total_revenue - total_admin_discount 
  end
end