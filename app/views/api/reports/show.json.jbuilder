json.data do
  json.(@report, :id, :name, :start, :stop)
  json.link api_report_path(@report)
  json.array!(@report.expenses, partial: "api/expenses/expense", as: :expense)
end

json.meta do
  json.links do
    json.self api_report_path(@report)
  end
end
