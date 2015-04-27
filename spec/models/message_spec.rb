require 'spec_helper'

describe Message do 

	before do
		@sender = FactoryGirl.create(:sender)
		@recipient = FactoryGirl.create(:recipient)
		@message = Message.new(sender_id: @sender.id, recipient_id: @recipient.id, message_text: "This is a test message")
		@message.save

	end

	subject { @message }

	it { should respond_to(:message_text) }
	it { should respond_to(:sender_id) }
	it { should respond_to(:recipient_id) }
	its(:sender) { should eq(@sender) }
	its(:recipient) { should eq(@recipient) }

	it {should be_valid }

	describe "when messsage is empty" do
		before { @message.message_text = " " }
		it { should_not be_valid }
	end
	
end