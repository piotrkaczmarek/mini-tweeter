require 'spec_helper'

describe Micropost do
  


  describe "validation" do
    #before { @micropost = user.microposts.build(content: "Lorem ipsum")}
    let(:micropost) { FactoryGirl.create(:micropost) }
 
    subject { micropost }

    it { should respond_to(:content)}
    it { should respond_to(:user_id)}
    it { should respond_to(:user)}
    it { should respond_to(:rating)}
    it { should respond_to(:rated_by)}
    it { should respond_to(:rates) }
    it { should respond_to(:add_rate) }
    it { should respond_to(:answer_to) }
    it { should respond_to(:answer_to_id) }
    it { should respond_to(:answered?) }

    it { should be_valid }

      describe "when user_id is not present" do
        before { micropost.user_id = nil }
        it { should_not be_valid }
      end

      describe "with blank content" do
        before { micropost.content = " " }
        it { should_not be_valid }
      end

      describe "with content that is too long" do
        before { micropost.content = "a" * 141 }
        it { should_not be_valid }
      end

      describe "when rating is higher than 5.0" do
        before do
          micropost.rating = 5.1
          micropost.rated_by = 1
        end
        it { should_not be_valid }
      end

      describe "when rating is lower than 0.0" do
        before do
          micropost.rating = -0.1
          micropost.rated_by = 1
        end
        it { should_not be_valid }
      end

      describe "when rated_by is negative" do
        before { micropost.rated_by = -2 }
        it { should_not be_valid }
      end
  end  
  
  describe "rating" do
    describe "add one rate by one user" do
        before do
          @micropost = FactoryGirl.create(:micropost)
          @micropost.add_rate(2,2)
        end
      it "should increase rated_by" do
        expect(@micropost.rated_by).to eq 1 
      end
      it "should have given rating" do
        expect(@micropost.rating).to eq 2 
      end
    end
    describe "when adding three rates by one user" do
      before do
        @micropost = FactoryGirl.create(:micropost)
        @micropost.rate_it(1,1)
        @micropost.save
        @micropost.rate_it(1,2)
        @micropost.save
        @micropost.rate_it(1,5)
        @micropost.save
      end
      it "should be rated by one user" do
        expect(@micropost.rated_by).to eq 1 
      end
      it "should not be rated by 2 users" do
        expect(@micropost.rated_by).to_not eq 2 
      end
      it "should have rating equal to the last rate" do
        expect(@micropost.rating).to eq 5 
      end
    end

    describe "when adding two rates by two users" do
      before do
        @micropost = FactoryGirl.create(:micropost)
        @micropost.rate_it(1,2)
        @micropost.rate_it(2,4)
      end
      it "should be rated by two users" do
        expect(@micropost.rated_by).to eq 2 
      end
      it "should have rating equal to the average of two rates" do
        expect(@micropost.rating).to eq 3.0
      end
    end
  end

  describe "#answer_to" do 
    before do
      @post1 = FactoryGirl.create(:micropost)
      @post2 = FactoryGirl.create(:micropost)
      @post2.answer_to_id = @post1.id
      @post2.save
    end
    it "should return original_post" do
      expect(@post2.answer_to).to eq @post1
    end
    it "should return nil if is not an answer" do
      expect(@post1.answer_to).to eq nil
    end

  end

  describe "#answered?" do
    describe "when no one answered" do
      before { @post2 = FactoryGirl.create(:micropost) }
      it "should be not answered" do
        expect(@post2.answered?).to eq false
      end      
    end
    describe "when post has been answered" do
      before do
        @post1 = FactoryGirl.create(:micropost)
        @post2 = FactoryGirl.create(:micropost)
        @post2.answer_to_id = @post1.id
        @post2.save
      end
      it "when some one answered" do
        expect(@post1.answered?).to eq true
      end
      it "when no one answered" do
        expect(@post2.answered?).to eq false
      end

    end
  end


end
