defmodule Kgb.Scraper do
  require HTTPotion
  require Floki
  
 @moduledoc """
 The Scraper module collects the raw HTML of each review, and extracts the name, date, text, and stars from the review.
 """
  @enforce_keys [:uri]
  defstruct [:uri, only_positives: true]

  @doc """
  Scrape the relevant information from the specified URI

  Parameters:
    uri: The URI to scrape

  Returns:
    An HTTPotion Response
  """
  def scrape!(uri) do
    HTTPotion.get(uri)
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
    |> Floki.text ## Get the text of the name
    |> String.replace("- ", "") ## Remove the hyphen/whitespace, and return
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
    |> Floki.text ## return the content
  end

  @doc """
  Parse the text out of a review

  Parameters:
     review_html: The Floki html tree of the review

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
     review: The html of the review

  Returns:
    An integer rating of the dealership
  """
  def avg_stars(review) do
    
  end

  @doc """
  Given an element that contains a rating class, return an integer value of the rating.
  
  Parameters:
    html: A floki html tree

  Returns:
    An integer between 10 and 50
  """
  def star_rating(html) do
    [ classname | _ ] =
      html
      |> Floki.find(".rating-static")
      |> Floki.attribute("class")
    
    Kgb.Scraper.rating_from_class(classname)
  end

  def rating_from_class(class) do
    [ matched_class | _ ] = Regex.run(~r/rating-[0-9]{1,2}/, class)
    rating                = String.split(matched_class, "-") |> List.last
    int                   = Integer.parse(rating) |> elem(0)
    
    int
  end

end
