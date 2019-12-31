class CLI 

    def initialize
        welcome
    end

    def welcome
        puts "Hello!"
    end
    
    # response = RestClient.get("https://developers.zomato.com/api/v2.1/search?q=pizza", {"user-key" => "2b9423ad30cd3b08e5762a65bc190392"})
    # parsed_response = JSON.parse(response)
end
