json.data do
  json.array!(@expenses, partial: "api/reports/report", as: :report)
end

json.partial! "shared/pagination", group: @reports
