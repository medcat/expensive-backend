json.(report, :id, :name, :start, :stop)
json.link api_report_path(report)

json.user do
  json.(report.user, :id, :email)
end

json.expenses report.expenses do |expense|
  json.id expense.id
  json.link api_expense_path(expense)
end
