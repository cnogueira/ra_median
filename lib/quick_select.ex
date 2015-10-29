defmodule QS do

  def median([]), do: :error
  def median(list) do
    n = length list
    quick_select(list, n, (div n+1, 2))
  end

  defp quick_select(list, n, k) do
    :random.seed(:os.timestamp)
    {:ok, pivot} = Enum.fetch(list, :random.uniform(n)-1)
    {{lower, ll}, {equal, le}, {higher, lh}} = separate(list, pivot)
    cond do
      ll >= k       -> quick_select(lower, ll, k)
      ll + le >= k  -> hd(equal)
      true          -> quick_select(higher, lh, k-ll-le)
    end
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
