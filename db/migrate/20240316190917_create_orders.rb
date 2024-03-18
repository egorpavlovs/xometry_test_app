class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :state
      t.datetime :completion_date
      t.datetime :cancelation_date
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end

    add_index :orders, :state
    add_index :orders, :cancelation_date
  end
end
