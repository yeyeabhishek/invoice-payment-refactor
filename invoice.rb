class Invoice < ApplicationRecord
  # Invoices are created with amounts in dollars, converted to cents for storage
  before_validation :convert_to_cents, on: :create

  has_many :payments, dependent: :destroy

  validates :invoice_total, presence: true, numericality: { greater_than: 0 }

  # Returns true if the invoice is fully paid
  def fully_paid?
    amount_owed_cents.zero?
  end

  # Remaining amount owed in dollars (for UI / API use)
  def amount_owed
    BigDecimal(amount_owed_cents) / 100
  end

  # Records a payment against the invoice
  # @param amount_paid [Numeric] Amount in dollars
  # @param payment_method [Symbol] :cash, :check, or :charge
  def record_payment(amount_paid, payment_method)
    payments.create!(
      amount: dollars_to_cents(amount_paid),
      raw_payment_method: payment_method
    )
  end

  private

  # Remaining amount owed in cents (internal use)
  def amount_owed_cents
    invoice_total - payments.sum(:amount)
  end

  # Convert invoice total from dollars to cents
  def convert_to_cents
    self.invoice_total = dollars_to_cents(invoice_total)
  end

  def dollars_to_cents(amount)
    raise ArgumentError, "Amount must be positive" if amount.nil? || amount <= 0

    (BigDecimal(amount.to_s) * 100).to_i
  end
end
