class SearchService::Products < SearchService
  FILTERS = {}.freeze

  PER_PAGE = 5
  PAGE = 1
  SORT = { name: :asc }.freeze

  def self.call(params = {})
    new(params).call
  end

  def initial_scope
    # TODO: Move to pg view
    @initial_scope ||= Product.left_joins(:order_items)
                        .select('products.*, SUM(CAST(order_items.quantity AS INTEGER)) AS order_items_sum')
                        .group('products.id')
  end
end
