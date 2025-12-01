# == Schema Information
#
# Table name: transactions
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
  belongs_to :subscription, optional: true

  monetize :total_cents, :subtotal_cents, :paying_amount_cents
end
