defmodule Kgb.Review do
  @enforce_keys [:name, :date, :title, :text, :employees, :avg_stars]
  defstruct [:name, :date, :title, :text, :employees, :avg_stars]

  def perfect_ratings(review_list) do
    Enum.filter(review_list, fn(rev) -> rev.avg_stars == 50 end)
  end

  def custom_title?(review) do
    not (review.text =~ review.title)
  end

  def custom_titled_reviews(review_list) do
    Enum.filter(review_list, fn(rev) -> Kgb.Review.custom_title?(rev) end, &>=/2)
  end

  def order_by_review_len(review_list) do
    Enum.sort_by(review_list, fn(rev) -> String.length(rev.text) end)
  end

  def order_by_employee_count(review_list) do
    Enum.sort_by(review_list, fn(rev) -> rev.employees end, &>=/2)
  end

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
