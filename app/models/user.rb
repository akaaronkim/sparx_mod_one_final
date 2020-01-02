class User < ActiveRecord::Base
    has_many :reviews
    # create reviews 
        # 
    # display "my favorites" based on ratings >=4
   
end