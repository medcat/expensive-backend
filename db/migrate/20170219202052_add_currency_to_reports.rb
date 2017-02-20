class AddCurrencyToReports < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :currency, :string
  end
end
