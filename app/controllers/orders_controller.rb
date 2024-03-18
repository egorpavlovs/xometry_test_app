class OrdersController < BaseController
  PER_PAGE = 5

  def index
    render json: if search_orders.success?
        OrdersBlueprint.render_as_json(search_orders.value)
      else
        # TODO: Use more user-friendly error message from search_orders.error
        {
          message: 'Something went wrong. Please try again later.'
        }
      end
  end

  def create
    # Add more validations to the order creation process and move it to a service
    order = Order.new(order_params)

    if order.save
      render json: order, status: :created
    else
      render json: { message: order.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:customer_id, order_items: [:product_id, :quantity]).to_h
  end

  def search_params
    params.permit(:state, :cancelation_date_from, :cancelation_date_to, :page).to_h
  end

  def search_orders
    SearchService::Orders.call(search_params)
  end
end
