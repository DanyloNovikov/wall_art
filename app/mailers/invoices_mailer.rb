class InvoicesMailer < ApplicationMailer
  def new_invoice_notification(invoice, admin)
    @invoice = invoice

    mail(
      to: admin.email,
      subject: "New Invoice ##{@invoice.id} Created"
    )
  end
end
