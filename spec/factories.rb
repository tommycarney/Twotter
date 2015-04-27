FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Person #{n}"}
		sequence(:email) { |n| "person_#{n}@example.com"}
		password "foobar"
		password_confirmation "foobar"

		factory :admin do
			admin true
		end
	end

	factory :micropost do
		content "lorem ipsum"
		user
	end
	factory :userToReplyTo, class: User do | user |
    	user.name "Donald Duck"
   		user.email "donald@entenhausen.de"
   		user.password "foobar"
    	user.password_confirmation "foobar"
 	end

 	factory :sender, class: User do | user |
    	user.name "Thomas Thompson"
   		user.email "test@tommycarney.com"
   		user.password "foobar"
    	user.password_confirmation "foobar"
 	end

 	factory :recipient, class: User do | user |
    	user.name "Test McTeston"
   		user.email "test2@tommycarney.com"
   		user.password "foobar"
    	user.password_confirmation "foobar"
 	end

 	sequence :email do |n|
    	"person-#{n}@example.com"
    end
end