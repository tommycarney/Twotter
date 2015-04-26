require 'spec_helper'

describe Micropost do
	
	before do
		@user = FactoryGirl.create(:user)
		@micropost = @user.microposts.build(content: "Lorem ipsum")
	end

	subject { @micropost }

	it { should respond_to(:content) }
	it { should respond_to(:user_id)}
	it { should respond_to(:user) }
	it { should respond_to(:in_reply_to_id)}
	its(:user) { should eq @user }

	it { should be_valid }

	describe "when user_id is not present" do
		before { @micropost.user_id = nil }
		it { should_not be_valid }
	end

	describe "with blank content" do
		before { @micropost.content = " " }
		it { should_not be_valid}
	end

	describe "with content that is too long" do
		before { @micropost.content = "a" * 142 }
		it { should_not be_valid }
	end

	describe "replies" do
		before(:each) do
			@reply_to_user = FactoryGirl.create(:userToReplyTo)
			@micropost = @user.microposts.create(content: "@Donald_Duck look a reply to Donald")
		end
		it "should identify a @user and set the in_reply_to field accordingly" do
			@micropost.in_reply_to.should == @reply_to_user
		end
	end
end
