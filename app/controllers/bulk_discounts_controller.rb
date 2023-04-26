class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @holiday = Holiday.find(params[:holiday_id]) if !params[:holiday_id].nil?
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @new_discount = @merchant.bulk_discounts.new(discount_params)
    if @new_discount.save
      flash[:alert] = "New Discount Created!"
      @new_discount.holiday_bulk_discounts.create(holiday_id: params[:bulk_discount][:holiday_id])
      redirect_to merchant_bulk_discounts_path(Merchant.find(params[:merchant_id]))
    else
      flash[:alert] = "Please fill out all fields correctly"
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    if @bulk_discount.update(discount_params)
      redirect_to merchant_bulk_discount_path(@bulk_discount.merchant, @bulk_discount)
    else
      flash[:alert] = "Please fill out all fields correctly"
      redirect_to edit_merchant_bulk_discount_path(@bulk_discount.merchant, @bulk_discount)
    end
  end

  def destroy
    
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

private
  def discount_params
    params.require(:bulk_discount).permit(:name, :threshold, :discount)
  end
end