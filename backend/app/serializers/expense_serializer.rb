class ExpenseSerializer < ActiveModel::Serializer
  type :expense
  attributes :id, :amount_currency, :amount_unit
  belongs_to :user

  attribute :amount_string do
    object.amount.format
  end

  link(:self) { api_expense_path(object.id) }
  link(:user) { api_user_path(object.user.id) }
end
