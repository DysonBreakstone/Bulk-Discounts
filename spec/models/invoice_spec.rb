require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end
  end

  describe "bulk discounts instance methods" do
    before do
      test_data
      @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "Discount 1", discount: 10, threshold: 5)
      @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: "Discount 2", discount: 20, threshold: 10)
      @bulk_discount_3 = @merchant_2.bulk_discounts.create!(name: "Discount 3", discount: 30, threshold: 15)
      @bulk_discount_4 = @merchant_2.bulk_discounts.create!(name: "Discount 4", discount: 40, threshold: 20)
    end

    it "#total_merchant_discount" do
      expect(@invoice_1.total_merchant_discount(@merchant_1)).to eq(250.0)
      expect(@invoice_2.total_merchant_discount(@merchant_1)).to eq(4300.0)
      expect(@invoice_4.total_merchant_discount(@merchant_2)).to eq(52900.0)
      expect(@invoice_4.total_merchant_discount(@merchant_1)).to eq(nil)
    end

    it "#this_merchant" do
      expect(@invoice_1.this_merchant(@merchant_1)).to eq([@invoice_item_1, @invoice_item_2, @invoice_item_3, @invoice_item_4, @invoice_item_5])

      @invoice_item_21 = @invoice_1.invoice_items.create!(item: @item_20, quantity: 20, unit_price: 2000, status: 1)

      expect(@invoice_1.this_merchant(@merchant_1)).to eq([@invoice_item_1, @invoice_item_2, @invoice_item_3, @invoice_item_4, @invoice_item_5])
    end

    it "#total_merchant_revenue" do
      expect(@invoice_3.total_merchant_revenue(@merchant_1)).to eq(0)
      expect(@invoice_3.total_merchant_revenue(@merchant_2)).to eq(85500.0)
      
      @invoice_item_21 = @invoice_3.invoice_items.create!(item: @item_1, quantity: 20, unit_price: 2000, status: 1)

      expect(@invoice_3.total_merchant_revenue(@merchant_2)).to eq(85500.0)
    end

    it "#total_sum" do
      expect(@invoice_1.total_sum(@merchant_1)).to eq(5250.0)
      expect(@invoice_3.total_sum(@merchant_2)).to eq(78750.0)
    end
  end
end
