json.(expense, :id, :time, :amount_currency, :amount_unit)
json.amount_string expense.amount.format
json.(expense, :description)
json.link api_expense_path(expense)
json.user do
  json.(expense.user, :id, :email)
  json.link ""
end
