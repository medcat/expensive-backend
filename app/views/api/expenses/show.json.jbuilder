json.data do
  json.partial! "api/expenses/expense", expense: @expense
end

json.meta do
  json.links do
    json.self api_expense_path(@expense)
  end
end
