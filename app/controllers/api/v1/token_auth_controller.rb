class Api::V1::TokenAuthController < ApplicationController
	
	protect_from_forgery :except => :get_user 

  	respond_to :json

	acts_as_token_authentication_handler_for User, {fallback: :none, if: lambda { |controller| controller.request.format.json? }}

	##returns the name of the user stored when the user signed up.
	def get_user

		if current_user
			render json: current_user, status: 200
		else
			render json: {errors: "no current user"}, status: 400
		end

	end

end


