class SearchService
  def initialize(params)
    @params = params
  end

  def call
    scope = if conditions.present?
        initial_scope.where(conditions).order(self.class::SORT)
      else
        initial_scope
      end

    Utils::Result.success(paginated_scope(scope))
  end

  private

  attr_reader :params

  def conditions
    self.class::FILTERS.each_with_object({}) do |(filter_name, filter_type), conditions|
      conditions.merge!(parse_filter(filter_name, filter_type))
    end
  end

  def parse_filter(filter_name, filter_type)
    case filter_type
    when :range
      range_filter_conditions(filter_name)
    else
      standard_filter_conditions(filter_name)
    end
  end

  def range_filter_conditions(filter_name)
    from = params["#{filter_name}_from".to_sym]
    to = params["#{filter_name}_to".to_sym]
    return {} if from.blank? && to.blank?

    range = if from.present? && to.present?
        from..to
      elsif from.present?
        from..Float::INFINITY
      else
        -Float::INFINITY..to
      end

    {
      filter_name => range
    }
  end

  def standard_filter_conditions(filter_name)
    value = params[filter_name]
    return {} if value.blank?

    { filter_name => value }
  end

  def paginated_scope(scope)
    return scope if params[:without_pagination]

    scope.page(params[:page] || self.class::PAGE).per(self.class::PER_PAGE)
  end
end
