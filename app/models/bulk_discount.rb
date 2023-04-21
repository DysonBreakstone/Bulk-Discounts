class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :merchant_id
  validates_numericality_of :discount
  validates_numericality_of :threshold
end