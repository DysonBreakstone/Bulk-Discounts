require 'rails_helper'

RSpec.describe HolidayBulkDiscount, type: :model do
  describe "relationships" do
    it {should belong_to :holiday}
    it {should belong_to :bulk_discount}
  end

  describe "validations" do
    it {should validate_presence_of(:holiday_id)}
    it {should validate_presence_of(:bulk_discount_id)}
  end
end