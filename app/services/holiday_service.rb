require 'httparty'
require 'json'

class HolidayService
  def get_info(url)
    response = HTTParty.get(url)
  end

  def us_holidays
    get_info('https://date.nager.at/api/v3/PublicHolidays/2023/US')
  end

end