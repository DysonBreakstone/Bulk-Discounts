class Holiday < ApplicationRecord
  validates_presence_of :date
  validates_presence_of :name
  has_many :holiday_bulk_discounts
  has_many :bulk_discounts, through: :holiday_bulk_discounts

  def self.next_three
    where("holidays.date >= ?", Time.now.to_date).order("date").limit(3)
  end

  def has_discount?(merchant)
    bulk_discounts.where("merchant_id = #{merchant.id}").size > 0
  end
end