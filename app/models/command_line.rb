
class CLI 
    #implements code in run method extracted from run.rb
    def run 
        welcome
        main_display_menu
        # menu_select
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

    # def menu_select
    #     user_input = gets.chomp
    #     case user_input
    #     when "1" 
    #         #define method below
    #         #create restaurants_in_my_area menu_select
    #         restaurants_in_my_area
    #     when "2"
    #         #define method below
    #         #create restaurants_by_rating menu_select
    #         restaurants_by_highest_rating
    #     when "3"
    #         #define method below
    #         #create restaurants_by_price menu_select
    #         restaurants_by_price
    #     when "4"
    #         #define method below
    #         #create restaurants_by_cuisine menu_select
    #         restaurants_by_cuisine
    #     else 
    #         main_display_menu
    # end

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
            price: restaurant["price"], 
            rating: restaurant["rating"], 
            phone: restaurant["phone"], 
            address: restaurant["location"]["display_address"].join(' '))
    end
end

def add_restaurants_to_db(restaurants = [])
    all_restaurants = search_restaurants
    all_restaurants.each do |current_restaurant|
        add_restaurant_to_db(current_restaurant)
    end
end

def restaurants_by_highest_rating 
    add_restaurants_to_db(search_restaurants)
    Restaurant.order(rating: :desc).last(10)
end

# def order_by_price(price)
#     if price == "$"
#         return 1
#     elsif price == "$$"
#         return 2
#     elsif price == "$$$"
#         return 3
#     else 
#         return 4
#     end
# end

def restaurants_by_price
    add_restaurants_to_db(search_restaurants)
    result = Restaurant.all.sort_by {|r| r.price}.reverse.first(10)
    binding.pry
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