json.data do
  json.array!(@reports, partial: "api/reports/report", as: :report)
end

json.partial! "shared/pagination", group: @reports
