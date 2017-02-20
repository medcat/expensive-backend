# encoding: utf-8

extend ExpenseDashboardHelper

json.data do
  json.topfigure do
    json.month_today do
      json.amount month_today_amount
      json.size month_today_size
    end

    json.week_today do
      json.amount week_today_amount
      json.size week_today_size
    end
  end

  json.expenses do
    json.array!(recent_expenses, partial: "api/expenses/expense", as: :expense)
  end

  json.reports do
    json.array!(recent_reports, partial: "api/reports/report", as: :report)
  end

  json.graph(graph_items)
end

json.meta do
  json.links do
    json.self api_dashboard_path
    json.expenses api_expenses_path
    json.reports ""
  end
end
