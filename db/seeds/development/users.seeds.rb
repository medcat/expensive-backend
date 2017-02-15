BASE = Rails.application.routes.default_url_options[:host]

ActiveRecord::Base.transaction do
  User.create!(email: "admin@#{BASE}", password: "password1234",
    password_confirmation: "password1234", admin: true)
  User.create!(email: "local@#{BASE}", password: "password1234",
    password_confirmation: "password1234")
end
