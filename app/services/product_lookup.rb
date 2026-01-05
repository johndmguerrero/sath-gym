class ProductLookup < RubyLLM::Tool
  description "gets latest information of products and plans available in the gym membership"

  def execute
    Product.includes(:product_plans)
      .map do |product|
        {
          id: product.id,
          name: product.name,
          description: product.description,
          status: product.status,
          plans: product.product_plans.map do |plan|
            {
              id: plan.id,
              interval: plan.interval,
              price: plan.price,
              interval_count: plan.interval_count
            }
          end
        }
      end
  end
end