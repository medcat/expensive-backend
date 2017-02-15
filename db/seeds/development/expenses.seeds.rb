BASE = Rails.application.routes.default_url_options[:host]

after :"development:users" do
  ActiveRecord::Base.transaction do
    user = User.find_by_email("local@#{BASE}")
    year = 1.year.ago
    now = DateTime.now
    description = proc do
      "#{Faker::App.name}: #{Faker::Hacker.say_something_smart}"
    end

    10_000.times do |i|
      amount = Faker::Number.decimal(2)
      price = Money.new(amount, "USD")
      Expense.create!(
        user: user,
        time: Faker::Time.between(year, now),
        description: description.call,
        amount: amount
      )
    end
  end
end
