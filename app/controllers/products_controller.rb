class ProductsController < BaseController
  PER_PAGE = 5

  def index
    render json: if search_products.success?
        ProductsBlueprint.render_as_json(search_products.value)
      else
        {
          message: 'Something went wrong. Please try again later.'
        }
      end
  end

  private

  def search_products
    SearchService::Products.call
  end
end
