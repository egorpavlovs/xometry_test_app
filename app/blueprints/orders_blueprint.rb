class OrdersBlueprint < Blueprinter::Base
  fields :name, :state

  field :completion_date do |item|
    item.completion_date.to_s
  end

  field :cancelation_date do |item|
    item.cancelation_date.to_s
  end

  field :customer_name do |item|
    item.customer.full_name
  end

  field :order_items do |item|
    item.order_items.map do |order_item|
      {
        name: order_item.product.name,
        quantity: order_item.quantity
      }
    end
  end
end
