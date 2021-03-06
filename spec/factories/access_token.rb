# == Schema Information
#
# Table name: api_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token_type :integer
#  title      :string(32)
#  token      :string(128)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :access_token do
    user { create(:user) }
    token_type 1
    permit_type 1
    title { Faker.name }
    token { SecureRandom.hex(32) }
  end
end
