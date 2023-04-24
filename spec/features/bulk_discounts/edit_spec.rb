require 'rails_helper'

RSpec.describe 'bulk discount edit page' do
  describe "display" do
    before do
      test_data
      @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "Discount 1", discount: 10, threshold: 5)
      @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: "Discount 2", discount: 20, threshold: 10)
      @bulk_discount_3 = @merchant_2.bulk_discounts.create!(name: "Discount 3", discount: 30, threshold: 15)
      @bulk_discount_4 = @merchant_2.bulk_discounts.create!(name: "Discount 4", discount: 40, threshold: 20)
    end

    it "has pre-filled fields" do
      visit edit_merchant_bulk_discount_path(@merchant_2, @bulk_discount_4)

      expect(page).to have_field("Name", with: "Discount 4")
      expect(page).to have_field("Threshold", with: 20)
      expect(page).to have_field("Discount", with: 40.0)
    end

    it "updates" do
      visit merchant_bulk_discount_path(@merchant_2, @bulk_discount_4)

      expect(page).to have_content("Discount 4")
      expect(page).to have_content("Item threshold: 20")
      expect(page).to have_content("Percent off: 40.0")

      expect(page).to have_no_content("Wacky Discount")
      expect(page).to have_no_content("Item threshold: 25")
      expect(page).to have_no_content("Percent off: 50.0")

      click_link("Edit this discount")

      fill_in("Name", with: "Wacky Discount")
      fill_in("Threshold", with: 25)
      fill_in("Discount", with: 50)
      click_button("Update Bulk discount")

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_2, @bulk_discount_4))
    end

    it "sad path" do
      visit edit_merchant_bulk_discount_path(@merchant_2, @bulk_discount_4)

      fill_in("Name", with: "")
      fill_in("Threshold", with: 25)
      fill_in("Discount", with: 50)
      click_button("Update Bulk discount")

      expect(page).to have_content("Please fill out all fields correctly")

      fill_in("Name", with: "Wacky discount")
      fill_in("Threshold", with: "bambi")
      fill_in("Discount", with: 50)
      click_button("Update Bulk discount")

      expect(page).to have_content("Please fill out all fields correctly")
    end
  end
end