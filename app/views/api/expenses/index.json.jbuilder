json.data do
  json.array!(@expenses, partial: "api/expenses/expense", as: :expense)
end

json.partial! "shared/pagination", group: @expenses
