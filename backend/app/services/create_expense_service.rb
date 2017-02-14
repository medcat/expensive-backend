# encoding: utf-8

class CreateExpenseService
  include ActiveModel::Validations
  attr_accessor :user, :amount, :currency, :time, :description

  validates :user, presence: true
  validates :amount, numericality:
    { greater_than_or_equal_to: 0, less_than_or_equal_to: (1 << 32 - 1) },
    presence: true
  validates :currency, inclusion: { in: Money::Currency.map(&:iso_code) },
    presence: true
  validates :time, presence: true
  validate :time_date

  def initialize(params)
    @user, @amount, @currency, @time, @description =
      params.values_at(:user, :amount, :currency, :time, :description)
  end

  def save
    return unless valid?
    Expense.create(expense_data)
  end

  def policy_class
    ExpensePolicy
  end

  def expense_data
    { user: @user,
      amount: value,
      time: @time,
      description: @description }
  end

  def value
    Money.from_amount(amount.to_f, currency)
  end

private

  def time_date
    return if @time.is_a?(::DateTime)
    return @time = @time.to_datetime if @time.is_a?(::Time) ||
      @time.is_a?(::Date)

    @time = ::DateTime.parse(@time || fail)
  rescue
    errors.add(:time, :not_date)
  end
end
