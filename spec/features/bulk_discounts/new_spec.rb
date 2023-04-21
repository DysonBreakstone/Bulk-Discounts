require 'rails_helper'

RSpec.describe "new bulk_discount page", type: :feature do
  before do
    test_data
    @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "Discount 1", discount: 10, threshold: 5)
    @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: "Discount 2", discount: 20, threshold: 10)
    @bulk_discount_3 = @merchant_2.bulk_discounts.create!(name: "Discount 3", discount: 30, threshold: 15)
    @bulk_discount_4 = @merchant_2.bulk_discounts.create!(name: "Discount 4", discount: 40, threshold: 20)
  end

  it "has fields to enter in bulk_discount information" do
    visit new_merchant_bulk_discount_path(@merchant_1)
    expect(page).to have_content("Enter Discount Information")

    expect(page).to have_field("Name")
    expect(page).to have_field("Threshold")
    expect(page).to have_field("Discount")
    expect(page).to have_button("Create BulkDiscount", href: "/merchant/#{@merchant_1.id}/bulk_discounts")
  end

  it "filling out form adds discount to index page" do
    visit merchant_bulk_discounts_path(@merchant_1)

    expect(page).to have_no_content("Discount 5")

    click_link("Create New Discount")
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))

    fill_in "Name", with: "Discount 5"
    fill_in "Threshold", with: 25
    fill_in "Discount", with: 50
    click_button "Create BulkDiscount"

    expect(current_path).to eq(visit merchant_bulk_discounts_path(@merchant_1))
    expect(page).to have_content("Discount 5")
  end

  describe "Sad Paths" do
    before do
      test_data
      @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "Discount 1", discount: 10, threshold: 5)
      @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: "Discount 2", discount: 20, threshold: 10)
      @bulk_discount_3 = @merchant_2.bulk_discounts.create!(name: "Discount 3", discount: 30, threshold: 15)
      @bulk_discount_4 = @merchant_2.bulk_discounts.create!(name: "Discount 4", discount: 40, threshold: 20)
    end

    it "enter no information"
  end

end