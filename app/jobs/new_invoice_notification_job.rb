class NewInvoiceNotificationJob < ApplicationJob
  queue_as :default

  def perform(invoice_id)
    invoice = Invoice.find_by(id: invoice_id)
    return unless invoice

    Admin.all.each do |admin|
      InvoicesMailer.new_invoice_notification(invoice, admin).deliver_later
    end
  end
end
