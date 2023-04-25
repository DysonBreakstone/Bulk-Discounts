require './app/services/holiday_builder'

InvoiceItem.destroy_all
Transaction.destroy_all
Invoice.destroy_all
Item.destroy_all
Customer.destroy_all
Merchant.destroy_all
Holiday.destroy_all

system('rails import')

HolidayBuilder.make_holidays