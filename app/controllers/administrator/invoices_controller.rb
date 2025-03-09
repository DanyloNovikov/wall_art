# frozen_string_literal: true

module Administrator
  class InvoicesController < BaseController
    before_action :set_invoice, only: %i[show]

    def index
      @invoices = Invoice.all.order(created_at: :desc)
    end

    def show; end

    private

    def set_invoice
      @invoice = Invoice.find(params[:id])
    end
  end
end
