class CreateExpenseReportRelationTable < ActiveRecord::Migration[5.0]
  def change
    coulmn_options = { id: :uuid, default: "uuid_generate_v4()" }
    create_join_table :expenses, :reports, coulmn_options: coulmn_options do |t|
      t.index :expense_id
      t.index :report_id
    end
  end
end
