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
end

