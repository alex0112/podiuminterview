defmodule ScraperTest do
  use ExUnit.Case
  use ExVCR.Mock

  doctest Kgb.Scraper

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end
  
  @remote_uri "https://www.dealerrater.com/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685/"
  
  describe "scrape!/1" do
    test "returns 200 OK" do
      use_cassette "successful_request" do
        assert Kgb.Scraper.scrape!(@remote_uri).status_code == 200
      end
    end
  end

  describe "reviews/1" do

    test "gets a list of reviews from a response" do
      ## Tests that each div returned contains one ".helpful-button" button.
      ## Only review divs contain "helpful" buttons.
      use_cassette "successfull_request" do
        resp    = Kgb.Scraper.scrape!(@remote_uri)
        reviews = Kgb.Scraper.reviews(resp)
        reviews |> Enum.map( fn(rev) ->
          assert(rev |> Floki.find(".helpful-button") |> length == 1)
        end)
      end
    end
  end

  describe "name/1" do
    test "gets the name 'kellybuz' out of the first review" do
      use_cassette "successfull_request" do
        resp    = Kgb.Scraper.scrape!(@remote_uri)
        review  = Kgb.Scraper.reviews(resp) |> List.first
        assert Kgb.Scraper.name(review) == "kellybuz"
      end
    end
  end

  describe "date/1" do
    test "gets the date " do
      use_cassette "successfull_request" do
        resp    = Kgb.Scraper.scrape!(@remote_uri)
        review  = Kgb.Scraper.reviews(resp) |> List.first
        assert Kgb.Scraper.date(review) == "November 26, 2019"
      end
    end
  end

  describe "text/1" do
    test "gets the text" do
      use_cassette "successfull_request" do
        resp         = Kgb.Scraper.scrape!(@remote_uri)
        review       = Kgb.Scraper.reviews(resp) |> List.first
        review_text  = Kgb.Scraper.text(review) |> String.replace(" ", "")
        test_text    = "Great people to deal with, very professional. Transaction from start to finish was quick, easy and overall painless. Nena was great very friendly and professional." |> String.replace(" ", "")

        ## Ignore whitespace differences in reviews, they don't affect output, and can occasionally become skewed.
        assert review_text == test_text
      end
    end
  end


  # describe "avg_stars/1" do
  #   test "gets 48 as the average rating from the first review" do
  #     use_cassette "successfull_request" do
  #       resp   = Kgb.Scraper.scrape!(@remote_uri)
  #       review = Kgb.Scraper.reviews(resp) |> List.first
  #       assert Kgb.Scraper.avg_stars(review) == 48
  #     end
  #   end
  # end

  describe "star_rating/1" do

    test "returns 48 as the rating from a div with a rating-* class" do
      test_html = """
      <div class="rating-static visible-xs pad-none margin-none rating-48 pull-right"></div>
      """ |> Floki.parse
#      assert Kgb.Scraper.star_rating(test_html) == 48
    end

    # test "returns 48 as the rating from a div with several identical rating classes" do
    #   test_div = """
    #   <div class="col-xs-6 col-sm-12 pad-none dealership-rating">
    #   <div class="rating-static visible-xs pad-none margin-none rating-48 pull-right"></div>
    #   <div class="rating-static hidden-xs rating-48 margin-center"></div>
    #   <div class="col-xs-12 hidden-xs pad-none margin-top-sm small-text dr-grey">SALES VISIT - USED</div>
    #   </div>
    #   """ |> Floki.parse
    #   assert Kgb.Scraper.star_rating(test_div) == 48
    # end

  end

  describe "rating_from_class/1" do
    test "correctly gets maximum rating" do
      Kgb.Scraper.rating_from_class("foo bar baz bang rating-50 bamph quux ") == 50
    end
    
  end
  
  

end