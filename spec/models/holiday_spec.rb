require 'rails_helper'

RSpec.describe Holiday, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :date }
  end

  describe "relationships" do
    it { should have_many :holiday_bulk_discounts }
    it { should have_many(:bulk_discounts).through(:holiday_bulk_discounts)}
  end

  describe "class methods" do
    before do
      HolidayBuilder.make_holidays
    end

    it "::next_three" do
      expect(Holiday.next_three.pluck("name")).to eq(["Memorial Day", "Juneteenth", "Independence Day"])
      expect(Holiday.next_three.pluck(:date).to_s).to eq("[Mon, 29 May 2023, Mon, 19 Jun 2023, Tue, 04 Jul 2023]")
    end
  end

  describe "instance methods" do
    before do
      test_data
      @bulk_discount_1 = @merchant_1.bulk_discounts.create!(name: "Discount 1", discount: 10, threshold: 5)
      @bulk_discount_2 = @merchant_1.bulk_discounts.create!(name: "Discount 2", discount: 20, threshold: 10)
      @bulk_discount_3 = @merchant_2.bulk_discounts.create!(name: "Discount 3", discount: 30, threshold: 15)
      @bulk_discount_4 = @merchant_2.bulk_discounts.create!(name: "Discount 4", discount: 40, threshold: 20)
      HolidayBuilder.make_holidays
    end

    it "#has_discount?" do
      expect(Holiday.first.has_discount?(@merchant_1)).to eq(false)
      @bulk_discount_1.holiday_bulk_discounts.create!(holiday_id: Holiday.first.id)
      expect(Holiday.first.has_discount?(@merchant_1)).to eq(true)
    end
  end
end

