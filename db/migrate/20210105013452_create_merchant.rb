class CreateMerchant < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      t.string :name

      t.timestamps
    end
  end
end

Invoice.joins(invoice_items: { merchant: :bulk_discounts }).where("invoices.id = 1 AND invoice_items.quantity >= bulk_discounts.threshold").select("invoices.id, invoice_items.id AS invoice_item_id, invoice_items.quantity, invoice_items.unit_price, MAX(bulk_discounts.discount) AS max_discount, bulk_discounts.name AS discount_name").group("invoices.id, invoice_items.id, bulk_discounts.name").select("invoices.id, SUM(invoice_items.quantity * invoice_items.unit_price * MAX(bulk_discounts.discount)) AS total_price, bulk_discounts.name AS discount_name")