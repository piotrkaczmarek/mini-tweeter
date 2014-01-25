require 'spec_helper'

describe Attachment do

  describe "validation" do
    let(:micropost) { FactoryGirl.create(:micropost) }
    let(:attachment) { micropost.attachments.create }

    subject { attachment }

    it { should respond_to(:micropost) }
    it { should respond_to(:file) }
    its(:micropost) { should eq micropost }
  end  
end
