require 'httparty'

class CostCalculator

  def initialize
    @url = "http://shopicruit.myshopify.com/products.json?page="
  end

  def get_total_cost
    page_num = 1
    total_cost = 0

    while !get_product_data(page_num).empty?
      puts "Reading page# #{page_num}"
      total_cost += get_cost_per_page(page_num)
      page_num += 1
    end
    total_cost.round(2)
  end

  private

  def get_product_data(page_num)
    response = HTTParty.get("#{@url}#{page_num}")
    response.parsed_response["products"]
  end

  def get_cost_per_page(page_num)
    product_data = get_product_data(page_num)
    clocks_and_watches = get_clocks_and_watches(product_data)
    calculate_cost(clocks_and_watches)
  end

  def get_clocks_and_watches(product_data)
    product_data.select do |product|
      product["product_type"] == "Watch" || product["product_type"] == "Clock"
    end
  end

  def calculate_cost(clocks_and_watches)
    cost = 0
    clocks_and_watches.each do |product|
      product["variants"].each do |varient|
        cost += varient["price"].to_f
      end
    end
    cost
  end

end

calculator = CostCalculator.new
total_cost = calculator.get_total_cost

puts "************************"
puts "Total Cost of all clocks and watches: $#{total_cost}"
puts "************************"


