require 'rest-client'

class RecordController < ApplicationController
	# @@apiPath = "localhost:8080/API"
	@@apiPath = "10.4.244.152:8080/web-api-0.1/Tickets"

	def index
	end

	def get
		query = @@apiPath

		if params[:dob] == nil && params[:license] == nil
			query = @@apiPath + "/FirstName/" + params[:first] + "/LastName/" + params[:last]
			session[:first] = params[:first]
			session[:last] = params[:last]
		elsif params[:license] == nil
			query = @@apiPath + "/FirstName/" + session[:first] + "/LastName/" + session[:last] + "/DoB/" + params[:dob]
			session[:dob] = params[:dob]
		else
			query = @@apiPath + "/FirstName/" + session[:first] + "/LastName/" + session[:last] + "/DoB/" + session[:dob] + "/License/" + params[:license]
			session[:license] = params[:license]
		end

		@q = query

		response = RestClient.get(query)

		if (response.body != "{}")
			@data = JSON.parse(response.body)
		else
			if params.length == 2
				@error1 = true
			elsif params.length == 3
				@error2 = true
			else
				@error3 = true
			end

			render "index"
		end
	rescue
		if params.length == 2
			@error1 = true
		elsif params.length == 3
			@error2 = true
		else
			@error3 = true
		end

		render "index"
	end
end
