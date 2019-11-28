defmodule Kgb.Review do
  @enforce_keys [:name, :date, :title, :text, :avg_stars]
  defstruct [:name, :date, :title, :text, :avg_stars]

  def perfect_ratings(review_list) do
    Enum.filter(review_list, fn(rev) -> rev.avg_stars == 50 end)
  end

  def custom_title?(review) do
    not (review.text =~ review.title)
  end

  def custom_titled_reviews(review_list) do
    Enum.filter(review_list, fn(rev) -> Kgb.Review.custom_title?(rev) end)
  end

  def order_by_review_len(review_list) do
    Enum.sort_by(review_list, fn(rev) -> String.length(rev.text) end)
  end
  
end

## Filter by
# - Perfect ratings
# - Custom Titles
# - Review Length
# - Number of employees interacted with
