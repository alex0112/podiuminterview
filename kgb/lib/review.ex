defmodule Kgb.Review do
  @enforce_keys [:name, :date, :title, :text, :employees, :avg_stars]
  defstruct [:name, :date, :title, :text, :employees, :avg_stars]

  @doc """
  Eliminate non-perfect ratings from a list
  """
  def perfect_ratings(review_list) do
    Enum.filter(review_list, fn(rev) -> rev.avg_stars == 50 end)
  end

  @doc """
  Return true if the title is not contained in the review text
  """
  def custom_title?(review) do
    title = String.replace(review.title, "...", "")
    not (review.text =~ title)
  end

  @doc """
  Eliminate reviews with non-custom titles
  """
  def custom_titled_reviews(review_list) do
    Enum.filter(review_list, fn(rev) -> Kgb.Review.custom_title?(rev) end)
  end

  @doc """
  Order by review length descending
  """
  def order_by_review_len(review_list) do
    Enum.sort_by(review_list, fn(rev) -> String.length(rev.text) end)
  end

  @doc """
  Order by employee count descending
  """
  def order_by_employee_count(review_list) do
    Enum.sort_by(review_list, fn(rev) -> rev.employees end, &>=/2)
  end


  @doc """
  Collect the top 3 users with the following criteria:
  - Left a perfect average rating
  - Created a custom title
  - Interacted with, remembered, and noted the greatest number of employees
  - Had one of the top 3 longest reviews
  """
  def top_three(review_list) do
    review_list
    |> Kgb.Review.perfect_ratings         ## Collect only perfect ratings
    |> Kgb.Review.custom_titled_reviews   ## Of these, collect only reviews with custom titles
    |> Kgb.Review.order_by_employee_count 
    |> Enum.take(10)                      ## Of these, take the top 10 with the most employee interaction
    |> Kgb.Review.order_by_review_len 
    |> Enum.take(3)                       ## Of these, take the top 3 longest reviews
  end
  
end
