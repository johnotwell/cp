FactoryGirl.define do
  factory :user, class: CoalescingPanda::User do
    account
    sequence :email do |n|
      "test#{n}@test.com"
    end

    sequence :name do |n|
      "Factory User #{n}"
    end

    sequence :canvas_user_id do |n|
      n
    end

    roles []

    factory :teacher do
      roles [:teacher]
    end

    factory :student do
      roles [:student]
    end

    factory :admin do
      roles [:admin]
    end
  end
end