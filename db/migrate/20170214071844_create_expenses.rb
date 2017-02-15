class CreateExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :expenses, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.datetime :time, null: false
      t.monetize :amount
      t.text :description, default: ""

      t.timestamps
    end
  end
end
