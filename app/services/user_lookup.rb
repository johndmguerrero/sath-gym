class UserLookup < RubyLLM::Tool
  description "Gets user information for referencing or looking up details by using customer_number"

  params do  # the params DSL is only available in v1.9+. older versions should use the param helper instead
    string :customer_number, description: "reference or unique identifier of the user with format of cust-XXXXXX"
  end

  def execute(customer_number:)

    return { error: "Customer Number must provide"} if customer_number.nil?

    user = User.includes(:user_address, :subscription).find_by customer_number: customer_number

    if user
      {
        success: true,
        user: user.as_json(include: [:user_address, :subscription])
      }
    else
      {
        success: false,
        error: "User not found"
      }
    end

  rescue => e
    {
      success: false,
      error: "An error occured: #{e.message}"
    }
  end
end