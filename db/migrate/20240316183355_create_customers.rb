class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :email
      t.string :full_name
      t.datetime :registration_date
      t.datetime :verification_date

      t.timestamps
    end
  end
end
