class Payment < ApplicationRecord
  PAYMENT_METHODS = {
    cash: 1,
    check: 2,
    charge: 3
  }.freeze

  belongs_to :invoice

  attr_accessor :raw_payment_method

  before_validation :set_payment_method_id, on: :create

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_method_id, inclusion: {
    in: PAYMENT_METHODS.values,
    message: "is not a valid payment method"
  }

  # Returns the payment method as a symbol
  def payment_method
    PAYMENT_METHODS.key(payment_method_id)
  end

  private

  def set_payment_method_id
    return if raw_payment_method.blank?

    unless PAYMENT_METHODS.key?(raw_payment_method)
      raise ArgumentError, "Invalid payment method: #{raw_payment_method}"
    end

    self.payment_method_id = PAYMENT_METHODS[raw_payment_method]
  end
end
