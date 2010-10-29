class AddDeliveryEstimative < ActiveRecord::Migration
  def self.up
    add_column :orders, :expected_delivery, :timestamp
    Order.all.each do |o|
      o.update_attributes({:expected_delivery => Time.now+3.days})
    end
  end

  def self.down
    remove_column :orders, :expected_delivery
  end
end
