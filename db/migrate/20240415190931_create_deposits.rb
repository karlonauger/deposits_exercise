class CreateDeposits < ActiveRecord::Migration[7.1]
  def change
    create_table :deposits do |t|
      t.decimal :amount
      t.date :deposit_date
      t.references :tradeline, null: false, foreign_key: true

      t.timestamps
    end
  end
end
