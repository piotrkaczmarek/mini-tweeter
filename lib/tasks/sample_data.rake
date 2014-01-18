namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
      make_users
      make_organizations
      make_microposts
      make_relationships
      add_rates
    end
  end

  def make_users
    admin = User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    60.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
  end

  def make_organizations
    users = User.all(limit: 5)
    users.each do |user|
      organization = Organization.create(name: "#{user.name}'s organization",
                                         admin_id: user.id)
      user.add_to(organization)
    end
    add_members
  end

  def add_members 
    organizations = Organization.all
    organizations.each do |organization|
      members = User.where(organization_id: nil).first(5)
      members.each do |member|
        member.add_to(organization)
      end
    end
  end

  def make_post(poster, answers, as_organization)
    content = Faker::Lorem.sentence(5)
    if answers and Micropost.any?
      range = [ Micropost.first.id, Micropost.last.id ]
      answer_to_id = Random.rand(range.min .. range.max)
    end
    if as_organization
      poster.microposts.create(content: content,
                               answer_to_id: answer_to_id,
                               organization_id: poster.organization_id)
    else
      poster.microposts.create(content: content,
                               answer_to_id: answer_to_id)
    end
  end


  def make_microposts
    users = User.all(limit: 30)
    10.times do
      content = Faker::Lorem.sentence(5)
      users.each do |user| 
        answers = true if Random.rand(0..1) == 1 
        as_organization = true if Random.rand(0..1) == 1
        make_post(user, answers, as_organization)
      end
    end
  end

  def add_rates
    microposts = Micropost.all
    microposts.each do |micropost|
      users = User.all.sample(rand(3..10))
      users.each do |user|
        micropost.rate_it(user.id,rand(1..5))
      end
    end
  end

  def make_relationships
    make_users_relationships
    make_organization_followers
  end

  def make_users_relationships
    users = User.all
    user = users.first
    followed_users = users[2..50]
    followers      = users[3..40]
    followed_users.each { |followed| user.follow!(followed) }
    followers.each      { |follower| follower.follow!(user) }
  end

  def make_organization_followers
    organizations = Organization.all
    i = 2
    organizations.each do |organization|
      followers = User.all[i..i+3]
      followers.each { |follower| follower.follow!(organization) }
      i += 1
    end
  end

end 
