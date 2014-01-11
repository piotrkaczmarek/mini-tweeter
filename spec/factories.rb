FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
    rated_by 0
    rating 0
  end

  factory :organization do
    name "LoremCorp"
    #association :admin, factory: :user
    #admin_id admin.id
  end
end
