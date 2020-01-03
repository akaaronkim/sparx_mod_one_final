class User < ActiveRecord::Base
    has_many :reviews
    has_many :restaurants, through: :reviews

    # binding.pry

    # create reviews 
    def create_review(restaurant, rating)
        Review.create(user: self, restaurant: restaurant, rating: rating)
    end

    # display "my favorites" based on ratings >=4
    def my_favorites
        self.reviews.map do |review|
             if review.rating >= 4
                review.restaurant
             end
        end.uniq 
    end

    #return list of all usernames
    def self.user_list
        self.all 
    end

   
end