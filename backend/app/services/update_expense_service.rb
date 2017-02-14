# encoding: utf-8

class UpdateExpenseService
  include ActiveModel::Validations
  attr_accessor :time, :description

  validates :amount, numericality:
    { greater_than_or_equal_to: 0, less_than_or_equal_to: (1 << 32 - 1) }
  validates :currency, inclusion: { in: Money::Currency.map(&:iso_code) }
  validate :time_date
  delegate :user, to: :expense

  def initialize(params)
    @id, @amount, @currency, @time, @description =
      params.values_at(:id, :amount, :currency, :time, :description)
  end

  def save
    return unless valid? && expense
    expense.update(expense_data) && expense
  end

  def expense
    @_expense ||= Expense.find(@id)
  end

  def policy_class
    ExpensePolicy
  end

  def expense_data
    data = {}
    # if either the amount or the currency was updated, update the whole thing.
    data[:amount] = value if @amount || @currency
    data[:time] = @time if @time
    data[:description] = @description if @description
    data
  end

  def value
    Money.from_amount(amount.to_f, currency)
  end


  def amount
    @amount || expense.amount_unit
  end

  def currency
    @currency || expense.amount_currency
  end

private

  def time_date
    return if @time.is_a?(::DateTime) || !@time
    return @time = @time.to_datetime if @time.is_a?(::Time) ||
      @time.is_a?(::Date)

    @time = ::DateTime.parse(@time)
  rescue ArgumentError
    errors.add(:time, :not_date)
  end
end
