require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com",
                            password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts)}
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users)}
  it { should respond_to(:followed_organizations) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:remember_token)}
  it { should respond_to(:organization)}
  it { should respond_to(:add_to)}
  it { should respond_to(:is_admin_of?)}

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when name is not present" do
    before { @user.name = "" }
   
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = "" }

    it { should_not be_valid }
  end 

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com user..@fsag..com ]
      addresses.each do | invalid_address |
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do | valid_address |
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExaMplE.COm" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "micropost associations" do
    
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost,user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost,user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end
    
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }
 
      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum")}
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  describe "#feed" do
    describe "when user follows other user and organization" do
      before do
        @user1 = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user)
        @user.save
      
        @organization = Organization.create(name: "Org1", admin_id: @user2.id)
        @user2.organization_id = @organization.id
        @user2.save

        @post1 = FactoryGirl.create(:micropost, user: @user1, created_at: 1.day.ago)
        @post2 = FactoryGirl.create(:micropost, user: @user2, organization_id: @organization.id, created_at: 1.hour.ago)
        @post3 = FactoryGirl.create(:micropost, user: @user, created_at: 2.hours.ago)
        @post4 = FactoryGirl.create(:micropost, user: @user2)
        
        @user.follow!(@user1)
        @user.follow!(@organization)
      end
      subject { @user }
      its(:feed) { should include(@post1) }
      its(:feed) { should include(@post2) }
      its(:feed) { should include(@post3) }
      its(:feed) { should_not include(@post4) }
      its(:feed) { should eq [@post2, @post3, @post1] }
    end
  end
  describe "#add_to_organization" do
    before do
      @user1 = FactoryGirl.create(:user)
    end

    describe "when organization exists" do
      before do
        @user2 = FactoryGirl.create(:user)
        @organization = Organization.create(name: "Org1", admin_id: @user2.id)
      end
      it "should set organization id" do
        @user1.add_to(@organization)
        expect(@user1.organization_id).to eq @organization.id
      end
    end

    describe "when organization doesn't exist" do
      it "should not change organization id" do
        @user1.add_to(nil)
        expect(@user1.organization_id).to eq nil
      end
    end
  describe "#is_admin_of?" do

    describe "user is the admin of organization" do
      before do
        @user1 = FactoryGirl.create(:user)
        @organization = Organization.create(name: "Org1", admin_id: @user1.id)
        @user1.add_to(@organization)
      end
      it "should return true" do
        expect(@user1.is_admin_of?(@organization)).to eq true
      end
    end
    
    describe "when user is not the admin of organization" do
      before do
        @user1 = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user)
        @organization = Organization.create(name: "Org1", admin_id: @user2.id)
      end
      it "should return false" do
        expect(@user1.is_admin_of?(@organization)).to eq false
      end
    end
  
    describe "when user is an admin of different organization" do
      before do
        @user1 = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user)
        @organization1 = Organization.create(name: "Org1", admin_id: @user1.id)
        @organization2 = Organization.create(name: "Org1", admin_id: @user2.id)
        @user1.add_to(@organization1)
        @user2.add_to(@organization2)
      end
      it "should return false" do
        expect(@user1.is_admin_of?(@organization2)).to eq false
      end
    end
    
    describe "when user is only a member of organization" do
      before do
        @user1 = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user)
        @organization2 = Organization.create(name: "Org1", admin_id: @user2.id)
        @user1.add_to(@organization2)
        @user2.add_to(@organization2)
      end
      it "should return false" do
        expect(@user1.is_admin_of?(@organization2)).to eq false
      end
    end


  end

  end

  describe "following other users" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end
  
    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

  describe "following organizations" do
    before do
      @organization_admin = FactoryGirl.create(:user)
      @organization = Organization.create(name: "Org1", admin_id: @organization_admin.id) 
      @organization_admin.organization_id = @organization.id
      @organization_admin.save!
      @user.save
      @user.follow!(@organization)
    end

    it { should be_following(@organization) }
    its(:followed_organizations) { should include(@organization) }

    describe "followed organization" do
      subject { @organization }
      its(:followers) { should include(@user) }
    end
    
    describe "and unfollowing" do
      before { @user.unfollow!(@organization) }

      it { should_not be_following(@organization) }
      its(:followed_organizations) { should_not include(@organization) }
    end


  end

  describe "organization" do
      before do
        @user.save
        @organization = Organization.create(name: "corpo", admin_id: @user.id)
        @user.organization_id = @organization.id
      end 
    describe "when user is admin" do
      its(:organization) { should eq @organization }
    end
    describe "when user is member" do
      before do
        @user2 = FactoryGirl.create(:user, { organization_id: @organization.id } )
      end
      it "its organization should be organization" do
        expect(@user.organization).to eq @organization
      end
    end
 
  end

  describe "#send_password_reset" do
    it "sends and email" do
      @user.send_password_reset
      ActionMailer::Base.deliveries.last.to.should == [@user.email]
    end
    it "should set password_reset_token" do
      @user.send_password_reset
      expect(@user.password_reset_token).to_not eq nil
    end
    it "should set password_reset_at" do
      @user.send_password_reset
      expect(@user.password_reset_sent_at).to_not eq nil
    end

  end
 
end
