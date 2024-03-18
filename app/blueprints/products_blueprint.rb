class ProductsBlueprint < Blueprinter::Base
  fields :name, :price

  field :order_items_sum do |item|
    item.try(:order_items_sum) || 0
  end
end
