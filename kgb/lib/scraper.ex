defmodule Kgb.Scraper do
  import Kgb.Review
  alias Kgb.Review, as: Review
  
  require HTTPotion
  require Floki
  
 @moduledoc """
 The Scraper module collects the raw HTML of each review, and extracts the name, date, text, and stars.
 """

  @doc """
  Make a request for the relevant information from the specified URI

  Parameters:
    uri: The URI to scrape
    page_no: The page number of review results to display (defaults to first)

  Returns:
    An HTTPotion Response
  """
  def fetch!(uri, page_no \\ 1) do
    cond do
      page_no == 1 ->
        HTTPotion.get(uri)
      page_no > 1 ->  
        uri = uri <> "page#{page_no}"
        HTTPotion.get(uri)
      end
  end

  @doc """
  Take an HTTPotion Response and construct a list of each review (as an HTML string)

  Parameters:
     resp: The HTTPotion response of a review page.

  Returns:
     An array of html trees containing reviews
  """

  def reviews(resp) do
    Floki.find(resp.body, ".review-entry")
  end

  @doc """
  Parse the customer name out of a review

  Parameters:
     review_html: The Floki html tree of the review

  Returns:
    The name of the customer
  """
  def name(review) do
    review
    |> Floki.find(".italic.font-18.black.notranslate") ## Find the div containing the name
    |> Floki.text                                      ## Get the text of the name
    |> String.replace("- ", "")                        ## Remove the hyphen/whitespace, and return
  end
  
  @doc """
  Parse the date out of a review

  Parameters:
     review_html: The html of the review

  Returns:
     The date of the review
  """
  def date(review) do
    review
    |> Floki.find(".italic.col-xs-6.col-sm-12.pad-none.margin-none.font-20") ## Find the div containing the review text
    |> Floki.text
  end

  @doc """
  Parse the text out of a review

  Parameters:
     review: The Floki html tree of the review

  Returns:
     The text of the review (string)
  """
  def text(review) do
    review
    |> Floki.find(".review-content")
    |> Floki.text
    |> String.trim
  end
  
  @doc """
  Parse the star rating of a review

  Parameters:
    review: The Floki html tree of the review

  Returns:
    An integer rating of the dealership
  """
  def avg_stars(review) do
    review
    |> Floki.find(".rating-static")
    |> Kgb.Scraper.star_rating
  end

  @doc """
  Given an element that contains a rating class, return an integer value of the rating.
  
  Parameters:
    html: A floki html tree

  Returns:
    An integer between 0 and 50
  """
  def star_rating(html) do
    [ classname | _ ] =
      html
      |> Floki.find(".rating-static") ## Find divs containing the rating-static class
      |> Floki.attribute("class")     ## Get a string of all classes associated with that div
    
    Kgb.Scraper.rating_from_class(classname)  ## Ascertain the star rating from the classnames
  end

  @doc """
  Given a string of css class names, parse out the star rating number

  Parameters:
    A string containing one or more class names

  Returns:
    An integer rating between 0 and 50
  """
  def rating_from_class(class) do
    [ matched_class | _ ] = Regex.run(~r/rating-[0-9]{1,2}/, class) ## Ratings come as a classname on the div, in the form `.rating-NN` 
    rating                = String.split(matched_class, "-") |> List.last
    {int, _}              = Integer.parse(rating)
    
    int
  end

  @doc """
  Get the title of a review

  Params:
    review: The Floki html tree of the review

  Returns:
    The title text of the review
  """
  def title(review) do
    review
    |> Floki.find("h3.no-format.inline.italic-bolder.font-20.dark-grey")
    |> Floki.text
    |> String.replace("\"", "") ## Replace double quotes in the review title
    |> String.trim
  end

  @doc """
  Count the number of employees the customer interacted with

  Parameters:
    review: The Floki html tree of the review

  Returns:
    An integer count of employees associated with the review
  """
  def employee_count(review) do
    review
    |> Floki.find(".review-employee")
    |> length
  end
    
  @doc """
  Initiate a request to the dealership page, and parse the data into a list 
  of Review structs

  Parameters:
    The URI to scrape

  Returns:
    A list of review structs
  """
  def scrape_reviews!(uri) do
    reviews = Kgb.Scraper.fetch!(uri) |> Kgb.Scraper.reviews
    Enum.map(reviews, fn(rev) ->
      %Review
      {
        name:      Kgb.Scraper.name(rev),
        date:      Kgb.Scraper.date(rev),
        title:     Kgb.Scraper.title(rev),
        text:      Kgb.Scraper.text(rev),
        employees: Kgb.Scraper.employee_count(rev),
        avg_stars: Kgb.Scraper.avg_stars(rev)
      }
    end)
  end
end
