class User < ActiveRecord::Base
  attr_accessible :followers, :twitter_id
end
