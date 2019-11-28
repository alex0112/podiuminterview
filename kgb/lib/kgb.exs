defmodule Kgb do
  @moduledoc """
  Print the top most positive reviews
  """

  require Kgb.Review
  require Kgb.Scraper

  @uri "https://www.dealerrater.com/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685/"

  def print() do
    reviews = Kgb.Scraper.scrape_reviews!(@uri, 5)
    top     = Kgb.Review.top_three(reviews)

    Enum.map(top, fn(rev) ->
      IO.puts """
      Name: #{rev.name}
      Date: #{rev.date}
      Title: #{rev.title}
      Review:
          #{rev.text}
      No. of Employees: #{rev.employees}
      Ratings: #{rev.avg_stars}
      """
    end)
    
  end
  
end

IO.puts "Fetching data"
Kgb.print()
IO.puts "\n\nDone."
