FactoryGirl.define do
  factory :expense do

    time { 2.weeks.ago }
    amount { Money.from_amount(2.00, "USD") }
    description { "nothing here" }
    user
  end
end
