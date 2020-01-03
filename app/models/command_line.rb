
class CLI 
    #implements code in run method extracted from run.rb
    def run 
        welcome
        main_display_menu
        menu_select
    end
    
    #displays welcome message
    def welcome
        puts Rainbow("
                ,-\"-. 
              _r-----i \"        _
              \\      |-.      ,***. 
               |     | |    ,-------. 
               |     | |   c|       |                       ,--. 
               |     |'     |       |      _______________ C|  | 
               (=====)      =========      \\_____________/  `=='   dla 
             (HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH) 
        ").blue
    end

    def main_display_menu
        puts "\n
        Please select from the following options - using numbers (1-4) as your input:\n
        - 1 - List of Restaurants 
        - 2 - Search restaurants by rating
        - 3 - Search restaurants by price
        - 4 - Search restaurants by cuisine
        -------------------------------------------------------------------------------
        "
    end
    
    def price_display_menu
        puts "\n
        Please select from the following options - using numbers (1-4) as your input:\n
        - 1 - $
        - 2 - $$
        - 3 - $$$
        - 4 - $$$$
        -------------------------------------------------------------------------------
        "
    end

    def rating_display_menu
        puts "\n
        Please select from the following options - using numbers (1-4) as your input:\n
        - 1 - First date options
        - 2 - Good, but not first date great
        - 3 - Monday, Tuesday, and Wednesday 
        - 4 - Restaurants to bring your in-laws
        -------------------------------------------------------------------------------
        "
    end

    def menu_select
        user_input = gets.chomp
        case user_input
        when "1" 
            #define method below
            #create restaurants_in_my_area menu_select
            # restaurants_in_my_area
        when "2"
            #create restaurants_by_rating menu_select
            # restaurants = restaurants_by_highest_rating
            # restaurants.each_with_index do |r, i|
            #     puts "#{i + 1}. #{r.name} - #{r.rating}"
            # end
            rating_display_menu
            user_rating_input
            return_back_to_menu
        when "3"
            #create restaurants_by_price menu_select
            # restaurants = restaurants_by_price(20)
            # restaurants.each_with_index do |r, i|
            #     puts "#{i + 1}. #{r.name} - #{r.price}"
            price_display_menu
            
            # more_restaurants = user_price_input
            user_price_input(restaurants, 5)
            return_back_to_menu
        when "4"
            # let the user enter a cuisine
            # search for records in the db that match that cuisine
            #create restaurants_by_cuisine menu_select
            user_cuisine_input
            return_back_to_menu
        else 
            main_display_menu
        end
    end

    API_KEY = "V8luDogdQ0cBLfJHPmm_sE1GEWqh1Zt4VJwBPzY_8oQKYByfmoJnjEemi0uC1x_4ZysZYHj9qMfceed5Avt5-QnIq3h7CE1N1ThEIG4EhKskNhNZj1d9mhxTRXULXnYx"
    # Constants, do not change these
        API_HOST = "https://api.yelp.com"
        SEARCH_PATH = "/v3/businesses/search"
        BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path
        DEFAULT_BUSINESS_ID = "yelp-san-francisco"
        DEFAULT_TERM = "restaurant"
        DEFAULT_LOCATION = "San Francisco, CA"
        SEARCH_LIMIT = 50

    def search(term, location)
    url = "#{API_HOST}#{SEARCH_PATH}"
    params = {
        term: term,
        location: location,
        limit: SEARCH_LIMIT
    }
    response = HTTP.auth("Bearer #{API_KEY}").get(url, params: params)
    response.parse
    end

    def search_restaurants
        all_restaurants = search(DEFAULT_TERM, DEFAULT_LOCATION)["businesses"]
    end

    def add_restaurant_to_db(restaurant = nil)
        if !restaurant
            return nil
        end
        
        if !Restaurant.find_by(name: restaurant["name"])

            Restaurant.create(
                name: restaurant["name"], 
                category: restaurant["categories"][0]["title"], 
                price: restaurant["price"] || "$", 
                rating: restaurant["rating"], 
                phone: restaurant["phone"], 
                address: restaurant["location"]["display_address"].join(' '))
        end
    end

    def add_restaurants_to_db(restaurants = [])
        all_restaurants = search_restaurants
        if all_restaurants == nil
            return nil
        end

        all_restaurants.each do |current_restaurant|
            add_restaurant_to_db(current_restaurant)
        end
    end
    
    def print_restaurant(restaurant)
        puts "
        #{restaurant.name}, 
        #{restaurant.category}, 
        #{restaurant.price}, 
        #{restaurant.rating}, 
        #{restaurant.phone}, 
        #{restaurant.address} 

        -------------------------------------
        "
    end

    def print_restaurants(restaurants)
        restaurants.each {|r| print_restaurant(r)}
    end

    def restaurants_by_highest_rating 
        add_restaurants_to_db(search_restaurants)
        Restaurant.order(rating: :asc).reverse.first(20)
    end

    def user_rating_input
        #print restaurants that have a specific price range
        user_input = gets.chomp
        case user_input
        when "1"   
            restaurants = Restaurant.all.select do |r|
                if r.rating == 5.0
                    puts print_restaurant(r)
                    end
                end
        when "2"
            restaurants = Restaurant.all.select do |r|
            if r.rating == 4.5
                puts print_restaurant(r)
                end
            end
        when "3"
          restaurants = Restaurant.all.select do |r|
           if r.rating == 4
                puts print_restaurant(r)
                end
            end
        when "4"        
                puts "
                So bad we don't have data
                
                _______________________________
                "
        else
        puts "You did not choose an option so we chose for you"
        end
     end

    def restaurants_by_price(limit)
        add_restaurants_to_db(search_restaurants)
        Restaurant.all.sort_by {|r| r.price}.reverse.first(limit)
    end

    def restaurants_by_price_range(price_range)
        Restaurant.where(price: price_range)
    end


    def user_price_input(restaurant, limit)
        #print restaurants that have a specific price range
        user_input = gets.chomp
        case user_input
        when "1"   
            restaurants = Restaurant.all.select do |r|
                r.price == "$"
                end
        when "2"
            restaurants = Restaurant.all.select do |r|
            r.price == "$$"
            end
        when "3"
          restaurants = Restaurant.all.select do |r|
            r.price == "$$$"
            end
        when "4"
        restaurants = Restaurant.all.select do |r|
            r.price == "$$$$"
            end
        else
        puts "You did not choose an option so we chose for you"
        end
        print_restaurants(restaurants)
     end

    def restaurants_by_cuisine(cuisine, limit)
        add_restaurants_to_db(search_restaurants)
        result = Restaurant.where(category: cuisine).first(limit)
    end

    def user_cuisine_input
       possible_cuisines = print_cuisines
       
       user_input = gets.chomp
       case user_input
       when "1"
        restaurants = restaurants_by_cuisine(possible_cuisines[0], 5)
       when "2"
        restaurants = restaurants_by_cuisine(possible_cuisines[1], 5)
       when "3"
        restaurants = restaurants_by_cuisine(possible_cuisines[2], 5)
       when "4"
        restaurants = restaurants_by_cuisine(possible_cuisines[3], 5)
       when "5"
        restaurants = restaurants_by_cuisine(possible_cuisines[4], 5)
       when "6"
        restaurants = restaurants_by_cuisine(possible_cuisines[5], 5)
       when "7"
        restaurants = restaurants_by_cuisine(possible_cuisines[6], 5)
       when "8"
        restaurants = restaurants_by_cuisine(possible_cuisines[7], 5)
       when "9"
        restaurants = restaurants_by_cuisine(possible_cuisines[8], 5)
       when "10"
        restaurants = restaurants_by_cuisine(possible_cuisines[9], 5)
       else 
        puts "You did not choose an option so we chose for you"
        restaurants = restaurants_by_cuisine(possible_cuisines.sample, 5)
       end
       print_restaurants(restaurants)
    end
    
    
    def print_cuisines
        cuisines = []
        10.times do
            cuisines << Restaurant.all.sample.category
        end
        cuisines.uniq!
        cuisines.each_with_index do |cuisine_type, i|
            puts "#{i + 1}. #{cuisine_type}"
        end
        cuisines
    end

    def return_back_to_menu
        puts "Would you like to return to the main menu?"
        puts "Press 'y' for yes"
        puts "Press 'n' for no"
        puts "-----------------------------------------"
        
        user_input = gets.chomp
        if user_input == "y"
            main_display_menu
            menu_select
        elsif user_input == "n"
            puts "Would you like to exit the application"
            puts "Press 'y' for yes"
            puts "-----------------------------------------"

            user_input == gets.chomp
            if user_input == "y"
                puts "
                
                Too bad. You're returning back to the main menu
                
                _________________________________________________
                "
                main_display_menu
                menu_select
            else
                main_display_menu
                menu_select
            end
        end
    end

    # def restaurants_in_my_area
    #     # call the api and grab all the restaurants
    #     all_restaurants = search_restaurants
    #     # iterate over the restaurants, adding all the ones that arent in the db to the db
    #     all_restaurants.each do |current_restaurant|
    #         add_restaurant_to_db(current_restaurant)
    #     end
    #     Restaurant.find_by()
    #     # retrieve the restaurants from db that are in area
    # end
end