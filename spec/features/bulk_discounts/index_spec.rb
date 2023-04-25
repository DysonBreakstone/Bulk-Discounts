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

  describe "user story 2 - create" do
    before do
      test_data
    end
    
    it "has a link to new bulk discount page" do
      visit merchant_bulk_discounts_path(@merchant_2)

      expect(page).to have_link("Create New Discount", href: new_merchant_bulk_discount_path(@merchant_2))
    end
  end

  describe "user story 3 - delete" do
    before do 
      test_data
      @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "Discount 1", discount: 10, threshold: 5)
      @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: "Discount 2", discount: 20, threshold: 10)
      @bulk_discount_3 = @merchant_2.bulk_discounts.create!(name: "Discount 3", discount: 30, threshold: 15)
      @bulk_discount_4 = @merchant_2.bulk_discounts.create!(name: "Discount 4", discount: 40, threshold: 20)
    end

    it "has delete links" do
      visit merchant_bulk_discounts_path(@merchant_2)

      expect(page.all(:button, "Delete").count).to eq(2)
    end

    it "deletes discounts" do
      visit merchant_bulk_discounts_path(@merchant_2)
   
      expect(page).to have_content("Discount 3")
      expect(page).to have_content("Discount 4")

      click_button("delete#{@bulk_discount_3.id}")

      expect(page).to have_no_content("Discount 3")
      expect(page).to have_content("Discount 4")

      click_button("delete#{@bulk_discount_4.id}")

      expect(page).to have_no_content("Discount 3")
      expect(page).to have_no_content("Discount 4")
    end
  end

  describe "holidays" do
    before do
      test_data
      @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "Discount 1", discount: 10, threshold: 5)
      @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: "Discount 2", discount: 20, threshold: 10)
      @bulk_discount_3 = @merchant_2.bulk_discounts.create!(name: "Discount 3", discount: 30, threshold: 15)
      @bulk_discount_4 = @merchant_2.bulk_discounts.create!(name: "Discount 4", discount: 40, threshold: 20)
      HolidayBuilder.make_holidays
    end

    it "displays next three holidays" do
      visit merchant_bulk_discounts_path(@merchant_2)

      within("#holidays") do
        expect(page).to have_content("Upcoming Holidays:")
        within("#holiday#{Holiday.next_three.first.id}") do
        expect(page).to have_content("Memorial Day")
        expect(page).to have_content("Mon, 29 May 2023")
        end 
        within("#holiday#{Holiday.next_three.second.id}") do
        expect(page).to have_content("Juneteenth")
        expect(page).to have_content("Mon, 19 Jun 2023")
        end
        within("#holiday#{Holiday.next_three.third.id}") do
        expect(page).to have_content("Independence Day")
        expect(page).to have_content("Tue, 04 Jul 2023")
        end
      end
    end
  end

  describe "holiday discount extension" do
    before do 
      test_data
      HolidayBuilder.make_holidays
    end

    it "has buttons next to holidays" do
      visit merchant_bulk_discounts_path(@merchant_1)
      expect(page.all(:link, "Create Discount").count).to eq(3)
    end
    
    it "clicking button brings you to new form with pre-populated fields" do
      visit merchant_bulk_discounts_path(@merchant_1)
      click_link "holiday_discount#{Holiday.next_three.first.id}"

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))

      expect(page).to have_field("Name", with: "#{Holiday.next_three.first.name} Discount")
      expect(page).to have_field("Threshold", with: 2)
      expect(page).to have_field("Discount", with: 30)
      click_button "Create Bulk discount"

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))

      expect(page).to have_link("#{Holiday.next_three.first.name} Discount")
    end

    it "button disappears after creating discount" do
      visit merchant_bulk_discounts_path(@merchant_1)

      click_link "holiday_discount#{Holiday.next_three.first.id}"
      click_button "Create Bulk discount"

      expect(page.all(:link, "Create Discount").count).to eq(2)
    end
  end
end