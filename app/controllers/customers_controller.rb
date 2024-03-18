class CustomersController < BaseController
  PER_PAGE = 5

  def index
    @customers = Customer.page(params[:page]).per(PER_PAGE)

    render json: @customers
  end
end
