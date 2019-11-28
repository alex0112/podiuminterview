defmodule ReviewTest do
  use ExUnit.Case
  use ExVCR.Mock

  doctest Kgb.Review

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end
  
  @remote_uri "https://www.dealerrater.com/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685/"

  describe "perfect_ratings/1" do
    test "every review is five stars" do
      use_cassette "successful_request" do
        review_list   = Kgb.Scraper.scrape_reviews!(@remote_uri)
        filtered_list = Kgb.Review.perfect_ratings(review_list)
        Enum.map(filtered_list, fn(rev) -> assert(rev.avg_stars == 50) end)
      end
    end

    test "the proper number of reviews is returned" do
      use_cassette "successful_request" do
        review_list   = Kgb.Scraper.scrape_reviews!(@remote_uri)
        filtered_list = Kgb.Review.perfect_ratings(review_list)
        assert length(filtered_list) == 8
      end
    end
  end

  describe "custom_title?/1" do
    test "it correctly matches a custom title" do
      #cust_title_rev = %Review{name: "", date: "", title: "", text: "" avg_stars: 50}
    end
  end
  
  
end
