require "spec_helper"

describe UserMailer do
  describe "#password_reset(user)" do
    let(:user) { FactoryGirl.create(:user, password_reset_token: "xxxxxxx") }
    let(:mail) { UserMailer.password_reset(user) }
    
    describe "renders the headers" do
      it "renders the subject" do
        mail.subject.should eq("Mini-tweeter Password Reset")
      end
      it "renders the receiver email" do
        mail.to.should eq([user.email])
      end
      it "renders the sender email" do
        mail.from.should eq(["minitweeter@gmail.com"])
      end
    end
    it "assigns name" do
      mail.body.encoded.should match(user.name)
    end
    it "assigns password_reset_token" do
      mail.body.encoded.should match("xxxxxxx")
    end
    it "renders the body" do
      mail.body.encoded.should match("Hello #{user.name}!")
    end
  end

end
