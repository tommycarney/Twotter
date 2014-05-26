FactoryGirl.define do
	factory :user do
		name	"Thomas Carney"
		email	"tommy@tommycarney.com"
		password "foobar"
		password_confirmation "foobar"
	end
end