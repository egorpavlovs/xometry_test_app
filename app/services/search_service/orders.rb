class SearchService::Orders < SearchService
  FILTERS = {
    state: :string,
    cancelation_date: :range
  }.freeze

  PER_PAGE = 5
  PAGE = 1
  SORT = { name: :asc }.freeze

  def self.call(params = {})
    new(params).call
  end

  def initial_scope
    @initial_scope ||= Order.joins(:order_items, :customer)
  end
end
