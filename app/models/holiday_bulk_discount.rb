class HolidayBulkDiscount < ApplicationRecord
  validates_presence_of :holiday_id,
                        :bulk_discount_id

  belongs_to :holiday
  belongs_to :bulk_discount
end