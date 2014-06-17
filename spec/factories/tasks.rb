# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task do |f|
  f.sequence(:title) { |n| "name_#{n}" }
  f.sequence(:body) { "some text here" }
  f.sequence(:user_id) { 1 }
  f.sequence(:started) { Date.today }
  f.sequence(:ended) { Date.today }
  end
end
