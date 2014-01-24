require 'spec_helper'

describe PasswordResetsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'"do
    describe "when there is a user with given email" do
      let(:user) { FactoryGirl.create(:user) }
      before { user.stub(:send_password_reset) }

      it "should set flash notice" do
        post :create, {email: user.email}
        expect(flash[:notice]).to_not eq nil
      end

    end

    describe "when there is no user with given email" do
      it "should not call send_password_reset on any user" do

      end
      it "should set flash error" do
        post :create, { email: "fake@mail.com" }
        expect(flash[:error]).to_not eq nil
      end
    end
  end

  describe "PATCH 'update'"do
    describe "when token is found" do

      describe "when password has been reseted less than 2 hours ago" do
        let(:user) { FactoryGirl.create(:user,
                          password_reset_token: "xxx",
                          password_reset_sent_at: 1.hour.ago) }
        before do
          @old_digest = user.password_digest.to_s
          patch :update, { id: "xxx", user: { password: "barbar",
                        password_confirmation: "barbar" } }
        end 
        it "should change user's password" do
          expect(User.find(user.id).password_digest.to_s).to_not eq @old_digest
        end
        it "should set flash notice" do
          expect(flash[:notice]).to_not eq nil
        end
      end

      describe "when password has been reseted more than 2 hours ago" do
        let(:user) { FactoryGirl.create(:user,
                          password_reset_token: "xxx",
                          password_reset_sent_at: 3.hours.ago) }
        before do
          @old_digest = user.password_digest.to_s
          patch :update, { id: "xxx", user: { password: "barbar",
                        password_confirmation: "barbar" } }
        end 
        it "should not change user's password" do
          expect(User.find(user.id).password_digest.to_s).to eq @old_digest
        end
        it "should set error notice" do
          expect(flash[:error]).to_not eq nil
        end
 
      end
    end

    describe "when token is not found" do
        before do
          patch :update, { id: "xxx", user: { password: "barbar",
                        password_confirmation: "barbar" } }
        end 
        it "should not call update_attributes" do
          User.any_instance.should_not_receive(:update_attributes)
        end
    end
  end

end
