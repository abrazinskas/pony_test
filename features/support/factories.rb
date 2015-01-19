require 'factory_girl'

include ActionDispatch::TestProcess
FactoryGirl.define do

  factory :user do |u|
    @password = Faker::Internet.password
    email { Faker::Internet.email }
    password @password
    newsletters false
    #encrypted_password  Digest::MD5.hexdigest(@password)
    first_name { Faker::Name.name }
    role 'user'

    # creates many locations
    # IMPORTANT BUT ONLY USER.PROFILE = BUILD ... WORKED!
    after(:build) do |user, evaluator|
        user.profile=build(:profile, :user => user)
      for i in 1..3 do
        user.locations<< build(:location, :resource => user)
      end
    end

    factory :user_with_trips do
      ignore do
        trips_count 1
      end
      after(:create) do |user, evaluator|
        create_list(:trip, evaluator.trips_count, user: user, town: town)
      end
    end

  end

  factory :profile do |p|
    bio { Faker::Lorem.characters(500)}
    age 20
    occupation 'international student'
    user
    # Locations, 3 is minimum
    after(:build) do |profile, evaluator|
      profile.photo=build(:photo, :profile => profile)
    end

  end

  factory :photo do
    src {fixture_file_upload(Rails.root.join('features/files/valid.JPG'), 'image/jpg')}
    profile
  end

  factory :location do
    address 'Wellington'

    # polymorphic association
    association :resource, factory: :user
  end

  factory :trip do
    title { Faker::Name.title }
    start_date Time.now
    end_date Time.now + 3.day
    seats 10
    cost 100
    town
    user

    # after(:create) do |trip,evaluator|
    #   trip.comments.create
    #
    # end


  end

  factory :town do
    name {Faker::Lorem.characters(10)}
  end

  factory :transport do
    title {Faker::Lorem.characters(10)}
  end

  factory :comment do
    comment { Faker::Lorem.sentence 10 }
    commentable
    user
  end


end