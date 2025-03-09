class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.decimal :discount
      t.bigint :merchant_id

      t.timestamps
    end
  end
end
