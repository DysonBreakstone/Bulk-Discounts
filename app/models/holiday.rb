class Holiday < ApplicationRecord
  validates_presence_of :date
  validates_presence_of :name

  def self.next_three
    where("holidays.date >= ?", Time.now.to_date).order("date").limit(3)
  end
end