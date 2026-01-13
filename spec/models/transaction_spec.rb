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
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  subscription_id        :bigint
#
# Indexes
#
#  index_transactions_on_subscription_id  (subscription_id)
#
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
