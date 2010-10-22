class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.decimal :value
      t.integer :order_id
      t.string :card_number
      t.string :card_holder
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
