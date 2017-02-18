FactoryGirl.define do
  factory :report do
    name { "A Report" }
    start { 3.weeks.ago }
    stop { 1.week.ago }

    user
    transient do
      expenses_count 5
    end

    after(:create) do |report, eval|
      create_list(:expense, eval.expenses_count, user: report.user,
        reports: [report])
    end
  end
end
