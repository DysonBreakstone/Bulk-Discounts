require 'rails_helper'

RSpec.describe "index page", type: :feature do
  describe "display" do
    before do
      test_data
      @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "Discount 1", discount: 10, threshold: 5)
      @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: "Discount 2", discount: 20, threshold: 10)
      @bulk_discount_3 = @merchant_2.bulk_discounts.create!(name: "Discount 3", discount: 30, threshold: 15)
      @bulk_discount_4 = @merchant_2.bulk_discounts.create!(name: "Discount 4", discount: 40, threshold: 20)
    end
  

    it "shows merchant's discounts" do
      visit merchant_bulk_discounts_path(@merchant_1)

      expect(page).to have_content("Merchant 1's Bulk Discounts")
      expect(page).to have_content("Discount 1")
      expect(page).to have_content("Item threshold: 5")
      expect(page).to have_content("Percent off: 10")
      expect(page).to have_content("Discount 2")
      expect(page).to have_content("Item threshold: 10")
      expect(page).to have_content("Percent off: 20")
      expect(page).to have_no_content("Discount 3")
      expect(page).to have_no_content("Item threshold: 15")
      expect(page).to have_no_content("Percent off: 30")
      expect(page).to have_no_content("Discount 4")
      expect(page).to have_no_content("Item threshold: 20")
      expect(page).to have_no_content("Percent off: 40")

      visit merchant_bulk_discounts_path(@merchant_2)

      expect(page).to have_content("Discount 3")
      expect(page).to have_content("Item threshold: 15")
      expect(page).to have_content("Percent off: 30")
      expect(page).to have_content("Discount 4")
      expect(page).to have_content("Item threshold: 20")
      expect(page).to have_content("Percent off: 40")
      expect(page).to have_no_content("Discount 1")
      expect(page).to have_no_content("Item threshold: 5")
      expect(page).to have_no_content("Percent off: 10")
      expect(page).to have_no_content("Discount 2")
      expect(page).to have_no_content("Item threshold: 10")
      expect(page).to have_no_content("Percent off: 20")
    end

    it "has links to show pages" do
      visit merchant_bulk_discounts_path(@merchant_2)

      expect(page).to have_link("Discount 3", href: merchant_bulk_discount_path(@merchant_2, @bulk_discount_3))
      expect(page).to have_link("Discount 4", href: merchant_bulk_discount_path(@merchant_2, @bulk_discount_4))
    end
  end
end