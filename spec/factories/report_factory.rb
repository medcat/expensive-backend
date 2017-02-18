FactoryGirl.define do
  factory :report do
    name { "A Report" }
    start { 3.weeks.ago }
    stop { 1.week.ago }

    user
  end
end
