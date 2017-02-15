class Expense < ApplicationRecord
  monetize :amount_unit, with_model_currency: :amount_currency
  belongs_to :user
end
