class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :followers, through: :reverse_relationships, source: :follower
	has_many :replies, foreign_key: "in_reply_to_id", class_name: "Micropost"
	has_many :received_messages, foreign_key: "recipient_id", class_name: "Message"
	has_many :sent_messages, foreign_key: "sender_id", class_name: "Message"

	before_save { self.email.downcase! }
	before_create { generate_token(:remember_token) }
	validates :name, presence: true, length: {maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
					uniqueness: { case_sensitive: false }
	has_secure_password		
	validates :password, length: { minimum: 6 }

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def feed
		feed = Micropost.followed_by_including_replies(self)
	end

	def following?(other_user)
		relationships.find_by(followed_id: other_user.id)
	end

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end
	def shorthand
		name.gsub(/ /,"_")
  	end
	
	def self.shorthand_to_name(sh)
	  	sh.gsub(/_/," ")
	end

	def self.find_by_shorthand(shorthand_name)
	    all = where(name: User.shorthand_to_name(shorthand_name))
	    return nil if all.empty?
	    all.first
	end

	
	private


	def generate_token(column)
		begin
			self[column] = User.digest(User.new_remember_token)
		end while User.exists?(column => self[column])
	end	

end