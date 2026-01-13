# == Schema Information
#
# Table name: transactions
# Database name: primary
#
#  id                     :bigint           not null, primary key
#  paying_amount_cents    :integer          default(0), not null
#  paying_amount_currency :string           default("PHP"), not null
#  payment_method         :integer          default("cash"), not null
#  reference_number       :string
#  remarks                :string
#  subtotal_cents         :integer          default(0), not null
#  subtotal_currency      :string           default("PHP"), not null
#  total_cents            :integer          default(0), not null
#  total_currency         :string           default("PHP"), not null
#  transaction_type       :integer          default("checkout"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  subscription_id        :bigint
#
# Indexes
#
#  index_transactions_on_subscription_id  (subscription_id)
#
class Transaction < ApplicationRecord
  enum :payment_method, { cash: 0, e_wallet: 1, credit_card: 2, debit_card: 3, bank_transfer: 4 }
  enum :transaction_type, { checkout: 0, renewal: 1 }
  belongs_to :subscription, optional: true

  monetize :total_cents, :subtotal_cents, :paying_amount_cents

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id payment_method reference_number total_cents transaction_type updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[subscription]
  end

  def self.monthly_sales_data(months: 7)
    # Get the last N months including current month
    end_date = Time.current.end_of_month
    start_date = (end_date - (months - 1).months).beginning_of_month

    # Group transactions by month and sum total_cents
    monthly_totals = where(created_at: start_date..end_date)
                      .group("DATE_TRUNC('month', created_at)")
                      .sum(:total_cents)

    # Generate labels and data for all months in range
    labels = []
    checkout_data = []
    renewal_data = []

    months.times do |i|
      month_date = end_date - (months - 1 - i).months
      labels << month_date.strftime("%B")

      # Get totals for this month by transaction type
      month_start = month_date.beginning_of_month
      month_transactions = where(created_at: month_start..month_date.end_of_month)

      checkout_total = month_transactions.checkout.sum(:total_cents) / 100.0
      renewal_total = month_transactions.renewal.sum(:total_cents) / 100.0

      checkout_data << checkout_total.round(2)
      renewal_data << renewal_total.round(2)
    end

    {
      labels: labels,
      datasets: [
        {
          label: "Checkout Sales",
          borderColor: "#93c5fd",
          backgroundColor: "#93c5fd",
          data: checkout_data
        },
        {
          label: "Renewal Sales",
          borderColor: "#fda4af",
          backgroundColor: "#fda4af",
          data: renewal_data
        }
      ]
    }
  end
end
