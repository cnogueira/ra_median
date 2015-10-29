defmodule MoM do

  def median([]), do: :error
  def median(list) do
    n = length list
    quick_select(list, n, (div n+1, 2))
  end

  defp quick_select(list, n, k) do
    pivot = median_of_medians(list, n)
    {{lower, ll}, {equal, le}, {higher, lh}} = separate(list, pivot)
    cond do
      ll >= k       -> quick_select(lower, ll, k)
      ll + le >= k  -> hd(equal)
      true          -> quick_select(higher, lh, k-ll-le)
    end
  end

  # Returns an aproximation of the median for the given list of length len
  defp median_of_medians(list, len) when len <= 5, do: naive_median(list, len)
  defp median_of_medians(list, _) do
    partitions = Enum.chunk(list, 5, 5, [])
    medians = Enum.map(partitions, &(naive_median(&1, (length &1))))
    median_of_medians(medians, (length medians))
  end

  # selects the median of 'list' by sorting algorithm
  # running time O(n log n)
  defp naive_median(list, len) do
    sorted_list = Enum.sort(list)
    elem(Enum.fetch(sorted_list, (div len, 2)), 1)
  end

  # separates the elems list into 3 list
  # one for the elems < k
  # another for the elems == k
  # another for the elems > k
  defp separate([], _), do: {{[], 0}, {[], 0}, {[], 0}}
  defp separate([head | tail], k) do
    {{lower, ll}, {equal, le}, {higher, lh}} = separate(tail, k)
    cond do
      head < k  -> {{[head|lower], ll+1}, {equal, le}, {higher, lh}}
      head > k  -> {{lower, ll}, {equal, le}, {[head|higher], lh+1}}
      true      -> {{lower, ll}, {[head|equal], le+1}, {higher, lh}}
    end
  end

end
