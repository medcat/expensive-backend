module ExpenseDashboardHelper
  def recent_expenses
    @expenses.order(time: :DESC).limit(5)
  end

  def recent_reports
    @reports.order(created_at: :DESC).limit(5)
  end

  def graph_items
    past_month = 1.month.ago
    @expenses
      .where(time: past_month..now, amount_currency: currency)
      .group_by_day(:time)
      .sum(:amount_unit).map do |name, value|
        [name, Money.new(value, currency).to_s]
      end.to_h
  end

  def month_today_amount
    @_month_today_amount ||=
      Money.new(expenses_month_today.sum(:amount_unit), currency).format
  end

  def month_today_size
    @_month_today_size ||= expenses_month_today.size
  end

  def week_today_amount
    @_week_today_amount ||=
      Money.new(expenses_week_today.sum(:amount_unit), currency).format
  end

  def week_today_size
    @_week_today_size ||= expenses_week_today.size
  end

  def currency
    Money.default_currency.iso_code
  end

  def expenses_month_today
    @_expenses_month_today ||= begin
      start = now.beginning_of_month
      @expenses.where(time: start..now, amount_currency: currency)
    end
  end

  def expenses_week_today
    @_expenses_week_today ||= begin
      start = now.beginning_of_week
      @expenses.where(time: start..now, amount_currency: currency)
    end
  end

  def now
    @_now ||= DateTime.now
  end
end
