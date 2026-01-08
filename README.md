# Invoice & Payment Refactor Assignment

## Overview
This repository contains a refactored version of the provided Invoice and Payment
models. The goal of this exercise was to fix logical issues, improve readability,
follow Rails conventions, and make currency handling safe and explicit.

**Assumptions**
- Ruby 3.x
- Rails 7.x
- All monetary values are stored in cents in the database
- Public APIs and user-facing values use dollars

---

## Key Improvements

### 1. Corrected Business Logic
- Fixed the `fully_paid?` method, which previously returned incorrect results.
- Ensured remaining balance calculations are accurate and consistent.
- Supported partial payments and multiple payments per invoice.

### 2. Safe Money Handling
- Avoided floating-point arithmetic by using `BigDecimal`.
- Explicit conversion between dollars and cents.
- Clear separation between internal (cents) and external (dollars) representations.

### 3. Rails Best Practices
- Corrected model associations (`Invoice has_many :payments`, `Payment belongs_to :invoice`).
- Removed deprecated APIs such as `attr_accessible`.
- Used `before_validation` instead of `before_create` for safer data normalization.
- Ensured validations run before persistence.

### 4. Error Handling & Validation
- Used `create!` to fail fast on invalid payments.
- Added validations for positive invoice totals and payment amounts.
- Invalid payment methods raise descriptive errors.

### 5. Readability & Maintainability
- Improved method naming and documentation.
- Reduced hidden side effects and unnecessary callbacks.
- Kept the implementation intentionally minimal while ensuring correctness.

---

## Example Usage

```ruby
invoice = Invoice.create!(invoice_total: 200.00)

invoice.record_payment(100.00, :charge)

invoice.amount_owed    # => 100.0
invoice.fully_paid?    # => false
