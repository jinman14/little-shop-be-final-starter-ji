class Api::V1::Merchants::InvoicesController < ApplicationController
  before_action :set_merchant
  def index
    if params[:status].present?
      invoices = @merchant.invoices_filtered_by_status(params[:status])
    else
      invoices = @merchant.invoices
    end
    render json: InvoiceSerializer.new(invoices)
  end
  
  def update
    invoice = @merchant.invoices.find(params[:id])

    invoice.update!(invoice_params)

    render json: InvoiceSerializer.new(invoice)
  end
  
  private 
  
  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def invoice_params
    params.permit(:coupon_id)
  end
end