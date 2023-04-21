class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @new_discount = @merchant.bulk_discounts.new(discount_params)
    if @new_discount.save
      flash[:alert] = "New Discount Created!"
      redirect_to merchant_bulk_discounts_path(Merchant.find(params[:merchant_id]))
    else
      flash[:alert] = "Please fill out all fields correctly"
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  private
  def discount_params
    params.require(:bulk_discount).permit(:name, :threshold, :discount)
  end
end