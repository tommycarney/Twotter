class MicropostsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
	before_action :correct_user,	only: [:destroy]
	@@direct_message_regexp = /\Ad @([^\s]*)/
	

	def create
		message = micropost_params[:content]
		match = direct_message(message)
		if match
			


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

	private

	def micropost_params
		params.require(:micropost).permit(:content)
	end

	def correct_user
		@micropost = current_user.microposts.find_by(id: params[:id])
		redirect_to root_url if @micropost.nil?
	end

	def direct_message(message)
		if match = @@direct_message_regexp.match(message)
			return match
		end
	end
end