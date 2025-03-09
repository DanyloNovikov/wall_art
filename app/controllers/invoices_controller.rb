# frozen_string_literal: true

class InvoicesController < ApplicationController
  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      NewInvoiceNotificationJob.perform_later(@invoice)
      flash[:success] = 'Запрос успешно отправлен'
      redirect_to collection_path(invoice_params[:collection_id])
    else
      flash[:error] = @invoice.errors.full_messages.join(', ')
      redirect_to collection_path(invoice_params[:collection_id])
    end
  end

  private

  def invoice_params
    params.permit(:name, :surname, :phone, :plate_id, :collection_id)
  end
end
