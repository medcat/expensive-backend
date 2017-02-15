json.data do
  json.array!(@expenses, partial: "api/expenses/expense", as: :expense)
end

current_page = @expenses.current_page
total_pages = @expenses.total_pages
next_page = current_page + 1 > total_pages ? current_page : current_page + 1
prev_page = current_page - 1 < 1 ? current_page : current_page - 1

json.meta do
  json.pages do
    json.current current_page
    json.total total_pages

    json.links((1..total_pages).map do |i|
      api_expenses_path(page: i, format: :json)
    end)
  end

  json.links do
    json.next api_expenses_path(page: next_page, format: :json)
    json.prev api_expenses_path(page: prev_page, format: :json)
    json.self api_expenses_path(page: current_page, format: :json)
    json.none api_expenses_path(format: :json)
  end
end

