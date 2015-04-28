class MessagesController < ApplicationController
  def index
  	@received_messages = current_user.received_messages
  	@sent_messages = current_user.sent_messages
  end

end