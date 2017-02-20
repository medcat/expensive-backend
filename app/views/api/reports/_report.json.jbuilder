json.(report, :id, :currency, :name, :start, :stop)
json.link api_report_path(report)

policy = ReportPolicy.new(@current_user, report)

json.can_edit policy.update?
json.can_delete policy.destroy?

json.user do
  json.(report.user, :id, :email)
end
