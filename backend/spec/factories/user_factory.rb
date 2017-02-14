FactoryGirl.define do
  factory :user do
    sequence :email { |n| "user#{n}@test.example.com" }
    sequence :password { |n| "password#{n}" }
    password_confirmation { password }
  end
end
