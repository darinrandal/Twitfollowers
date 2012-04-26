require 'open-uri'

class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def show
		param = params[:data]
		if param.to_i == 0
			twitter_id = JSON.parse(open("https://api.twitter.com/1/users/lookup.json?screen_name=#{param}").read)[0]['id']
		else
			twitter_id = param
		end
		url = "https://api.twitter.com/1/followers/ids.json?id=#{twitter_id}"
		fetched_followers = JSON.parse(open(url).read)['ids']

		@local = User.where('twitter_id = ?', twitter_id)

		if @local.count == 0
			User.new(:twitter_id => twitter_id, :followers => '[' + fetched_followers.join(",") + ']').save
			@status = "created"
		else
			#User.update(@local[0].id, :followers => '[' + fetched_followers.join(",") + ']')
			@status = "did nothing"
		end

		local_followers = @local[0].followers.scan( /\d+/ ).map!{ |s| s.to_i }
		diffs = (local_followers | fetched_followers) - (local_followers & fetched_followers)

		@lost = Array.new
		@gained = Array.new
		diffs.each do |d|
			if local_followers.include?(d)
				@lost << d
			else
				@gained << d
			end
		end
	end
end
