# Kgb

**Shows top three most positive reviews**

## Running the program
```
mix deps.get && mix run lib/kgb.exs
```

## Testing
```
mix test
```

**Sorting Rationale:**
Reviews are sorted by reviewer effort.  The rationale being that those who went out of their way to provide extra information should be flagged and be suspected than those who did not.

Therefore, those who submitted the longest reviews, with custom titles and perfect ratings, are sorted by review length and the top three are selected.

##### External Libraries:
This project makes use of the `HTTPotion`, `ExVCR`, and `Floki` libraries.

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/kgb](https://hexdocs.pm/kgb).

