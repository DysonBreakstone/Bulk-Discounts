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

InvoiceItem.joins(invoice:  {merchants: :bulk_discounts}).select("invoice_items.id, invoice_items.quantity AS quantity, invoice_items.unit_price AS price, max(bulk_discounts.discount) AS discount").where("invoice_items.quantity >= bulk_discounts.threshold").distinct.order("invoice_items.id, discount").group("invoice_items.id")

Invoice.joins(merchants: :bulk_discounts).where("invoices.id = 1").select("invoice_items.*, max(bulk_discounts.discount)").group("invoice_items.id").select("invoices.id, sum(invoice_items.quantity * invoice_items.unit_price * bulk_discounts.discount) AS total_price").group("invoices.id").first.total_price

InvoiceItem.joins(invoice:  {merchants: :bulk_discounts}).where("invoice_items.quantity >= bulk_discounts.threshold AND invoices.id = 1 AND merchants.id = 1").select("invoice_items.id, invoice_items.quantity AS quantity, invoice_items.unit_price AS price, min(bulk_discounts.discount)").order("invoice_items.quantity").group("invoice_items.id")