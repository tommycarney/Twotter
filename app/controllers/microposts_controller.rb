class MicropostsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
	before_action :correct_user,	only: [:destroy]
	@@direct_message_regexp = /\Ad @([^\s]*)([\s\S]*)/
	

	def create
		check_content_for_message = direct_message(micropost_params[:content])
		if check_content_for_message
			create_message(check_content_for_message)
			return
		end

		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_url
	end

	def create_message(match)
		recipient = User.find_by_shorthand(match[1])

		if recipient
			message = Message.new(sender_id: current_user.id, recipient_id: recipient.id, message_text: match[2].strip)

			if message.save
				flash[:success] = "You just sent a message to #{recipient.name}!"
				redirect_to root_url
			else
				flash[:error] = "Sorry, there was an error in sending the message!"
				redirect_to root_url
			end
		else
			flash[:error] = "We couldn't find #{match[1]} in Twotter! You should invite #{match[1]}"
			redirect_to root_url
		end

	end	

	private

	def micropost_params
		params.require(:micropost).permit(:content)
	end

	def correct_user
		@micropost = current_user.microposts.find_by(id: params[:id])
		redirect_to root_url if @micropost.nil?
	end

	def direct_message(message)
		if match =/\Ad @([^\s]*)([\s\S]*)/.match(message)
			return match
		end
	end
end