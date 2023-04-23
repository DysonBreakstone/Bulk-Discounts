class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name
  validates_presence_of :merchant_id
  validates_numericality_of :discount
  validates_numericality_of :threshold

  before_save :make_percentage

  def make_percentage
    self.discount = (self.discount.to_f / 100).round(2)
  end
end