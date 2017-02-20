json.data do
  json.partial!("api/reports/report", report: @report)
  aggregate = @expenses
    .send(:"group_by_#{@period}", :time)
    .sum(:amount_unit).inject({}) do |acc, (name, value)|
      money = Money.new(value, @report.currency)
      name = name.to_datetime
      acc.merge!(name => { raw: money.to_s, format: money.format,
        time: name })
    end

  json.aggregate aggregate
  json._explain @expenses.send(:"group_by_#{@period}", :time).to_sql
end

json.meta do
  json.links do
    json.self api_report_path(@report)
  end
end
