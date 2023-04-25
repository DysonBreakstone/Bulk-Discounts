require './app/services/holiday_service'
require './app/models/holiday.rb'

class HolidayBuilder
  def self.service 
    HolidayService.new
  end

  def self.make_holidays
    JSON.parse(service.us_holidays.body, symbolize_names: true).each do |day|
      Holiday.create(name: day[:name], date: day[:date])
    end
  end
end