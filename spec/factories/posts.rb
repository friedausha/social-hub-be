FactoryBot.define do
  factory :post do
    title { Faker::Book.title }
    content { Faker::Lorem.paragraphs(number: 2).join("\n\n") }
    association :user
    sequence(:created_at) { |n| n.days.ago }
  end
end
# frozen_string_literal: true

