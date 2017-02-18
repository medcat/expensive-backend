class Report < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :name, presence: true, length: { in: 5..120 }
  validates :start, presence: true
  validates :stop, presence: true
  validate :start_time_date
  validate :stop_time_date
  validate :time_positions

  def expenses(force_reload = false)
    @_expenses = nil if force_reload
    @_expenses ||= Expense.where(user: user, time: start..stop)
  end

  def expense_ids
    expenses.pluck(:id)
  end

private

  def time_positions
    return unless start && stop
    return unless start > stop
    errors.add(:stop, :too_early)
  end

  def start_time_date
    return if start.is_a?(::DateTime)
    return self.start = start.to_datetime if start.is_a?(::Time) ||
      start.is_a?(::Date)

    self.start = ::DateTime.parse(start || fail)
  rescue
    errors.add(:start, :not_date)
  end

  def stop_time_date
    return if stop.is_a?(::DateTime)
    return self.stop = stop.to_datetime if stop.is_a?(::Time) ||
      stop.is_a?(::Date)

    self.stop = ::DateTime.parse(stop || fail)
  rescue
    errors.add(:stop, :not_date)
  end
end
