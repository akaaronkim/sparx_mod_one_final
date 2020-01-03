
class CLI 
    #displays welcome message
    def run 
        welcome
        menu_select
    end

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
        ").magenta
        display_menu
    end
    
    def display_menu
        puts "\n
        Please select from the following options - using numbers (1-4) as your input:\n
        - 1 - List of Restaurants 
        - 2 - Search restaurants by rating
        - 3 - Search restaurants by price
        - 4 - blah blah blah
      
        "
        end

        #gets user input from the menu page
        def menu_select
            user_input = gets.chomp
            case user_input
            when "1" 
             restaurant_info = restaurant_names
             #display choices for user 
             restaurant_names.each_with_index do |restaurant, i|
                puts "#{i + 1}: #{restaurant}"
                
             end
            
            when "2"
             popular_restaurants = restaurants_by_rating(search_restaurants["businesses"])

             # iterate through all the restaurants
              popular_restaurants.each do |restaurant|
                if !Restaurant.find_by(name: restaurant["name"])#if its in the db
                    Restaurant.create(
                    name: restaurant["name"], 
                    category: restaurant["categories"][0]["title"], 
                    price: restaurant["price"], 
                    rating: restaurant["rating"], 
                    phone: restaurant["phone"], 
                    address: restaurant["location"]["display_address"].join(' '))
                end
                    Restaurant.all
                #retrieve data from db
              end  
       
               # check to see if the current fucking restaurant is in the db
               # if the current fucking restaurant is not in the db
               # add that restaurant to the db
               # else, retrieve the information about that fucking restaurant from the db
             

            
             restaurant_choice = gets.chomp
             case restaurant_choice
             when "1"
                # check if restaurant is already in db
                is_in_db_already = Restaurant.find_by(name: restaurant_info[0])
                if is_in_db_already
                    puts is_in_db_already
                    # retrive it from db
                else
                # else call the api to retrieve it.
                restaurant = search_restaurant_info(restaurant_info[0])
                add_restaurant_to_db
                # puts restaurant

                # grab all of the restaurants by rating from yelp
                # if any of these restaurants are not in the databse, add them to the database
                # display the relevant information to the use
                end
            end
        end
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
    SEARCH_LIMIT = 10

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
    all_restaurants = search(DEFAULT_TERM, DEFAULT_LOCATION)
end

def search_restaurant_info(name)
    search_restaurants["businesses"].find do |restaurant|
        restaurant["name"] == name
    end  
end

def restaurant_names
    @all_restaurants =[]
    search_restaurants["businesses"].select do |element|
        element.each do |k,v|
            if k == "name"
                @all_restaurants << v
            end
        end
    end
    @all_restaurants
end

def restaurants_by_rating(restaurants)
    restaurants.sort_by {|restaurant| -restaurant["rating"]}
end

def add_restaurant_to_db(restaurant)
    Restaurant.create(
        name: restaurant["name"], 
        category: restaurant["categories"][0]["title"], 
        price: restaurant["price"], 
        rating: restaurant["rating"], 
        phone: restaurant["phone"], 
        address: restaurant["location"]["display_address"].join(' '))
end

def display_restaurant(restaurant)
    puts "Name: #{Restaurant.name}"
    puts "Category: #{Restaurant.category}"
    puts "Price: #{Restaurant.price}"
    puts "Rating: #{Restaurant.rating}"
    puts "Phone: #{Restaurant.phone}"
    puts "Address: #{Restaurant.address}"
end



#displays welcome message
#menu page for user
#obtains user input from menu page
#exits the app
#reroutes user back to menu
#def method that searches for restaurants in a given zipcode 
#search for highest rated restaurants
#random restaurant suggestion in given zipcode 