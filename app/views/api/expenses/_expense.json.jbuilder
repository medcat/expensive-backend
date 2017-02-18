json.(expense, :id, :time, :amount_currency, :amount_unit)
json.amount_string expense.amount.format
json.amount expense.amount.amount
json.(expense, :description)
json.link api_expense_path(expense)
json.user do
  json.(expense.user, :id, :email)
  json.link ""
end

policy = ExpensePolicy.new(@current_user, expense)

json.can_edit policy.update?
json.can_delete policy.destroy?
