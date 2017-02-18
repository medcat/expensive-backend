class Expense < ApplicationRecord
  monetize :amount_unit, with_model_currency: :amount_currency, allow_nil: true
  belongs_to :user
  has_and_belongs_to_many :reports

  MAXIMUM_AMOUNT_VALUE = (1 << 32) - 1

  validates :user, presence: true
  validates :amount_unit, numericality:
    { greater_than_or_equal_to: 0, less_than_or_equal_to: (1 << 32 - 1) },
    presence: true
  validates :amount_currency,
    inclusion: { in: Money::Currency.map(&:iso_code) }, presence: true
  validates :time, presence: true, date_time: true

private
end
