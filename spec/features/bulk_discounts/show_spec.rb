require 'rails_helper'

RSpec.describe "bulk discount show page" do
  describe "display" do
    before do
      test_data
      @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "Discount 1", discount: 10, threshold: 5)
      @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: "Discount 2", discount: 20, threshold: 10)
      @bulk_discount_3 = @merchant_2.bulk_discounts.create!(name: "Discount 3", discount: 30, threshold: 15)
      @bulk_discount_4 = @merchant_2.bulk_discounts.create!(name: "Discount 4", discount: 40, threshold: 20)
    end

    it "shows bulk discount name and attributes" do
      visit merchant_bulk_discount_path(@merchant_1, @bulk_discount_1)

      expect(page).to have_content("Discount 1")
      expect(page).to have_content("Merchant: Merchant 1")
      expect(page).to have_content("Item threshold: 5")
      expect(page).to have_content("Percent off: 10")
    end
  end
end