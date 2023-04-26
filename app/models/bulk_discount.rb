class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :holiday_bulk_discounts, dependent: :destroy
  has_many :holidays, through: :holiday_bulk_discounts

  validates_presence_of :name
  validates_presence_of :merchant_id
  validates_numericality_of :discount
  validates_numericality_of :threshold

end