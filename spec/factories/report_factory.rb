FactoryGirl.define do
  factory :report do
    name { "A Report" }
    start { 3.weeks.ago }
    stop { 1.week.ago }
    currency { "USD" }

    user
  end
end
