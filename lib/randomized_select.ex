defmodule RS do

  def median([]), do: :error
  def median(list), do: median(list, length list)

  defp median(list, n) when (rem n, 2) == 0, do: median([-1|list], n+1)
  defp median(list, n) do
    :random.seed(:os.timestamp)
    n34 = :math.pow(n, 0.75)
    sqrt_n = :math.sqrt(n)
    # get a randomized sorted sublist of length n34
    sublist = random_sublist(List.to_tuple(list), trunc(Float.ceil(n34)))
    sublist = Enum.sort(sublist)

    {:ok, d} = Enum.fetch(sublist, trunc(Float.ceil(n34/2 - sqrt_n)))
    {:ok, u} = Enum.fetch(sublist, trunc(Float.floor(n34/2 + sqrt_n)))
    {ll, {med, lm}, lh} = separate(list, d, u)


    if ll > n/2 or lh > n/2 or lm > 4*n34 do
      # If fail, repeat
      median(list, n)
    else
      # Else retrieve the median
      c = Enum.sort(med)
      elem(Enum.fetch(c, trunc(Float.floor(n/2-ll+1))-1),1)
    end
  end

  # returns a list containing random k elements of the given tuple
  defp random_sublist(_, 0), do: []
  defp random_sublist(tuple, k) do
    element = elem(tuple, :random.uniform(tuple_size tuple)-1)
    [element|random_sublist(tuple, k-1)]
  end

  # separates the elems list into 3 list
  # one for the     'elems < d'
  # another for the 'd <= elems <= u'
  # another for the 'elems > u'
  defp separate([], _, _), do: {0, {[], 0}, 0}
  defp separate([head | tail], d, u) do
    {ll, {med, lm}, lh} = separate(tail, d, u)
    cond do
      head < d  -> {ll+1, {med, lm}, lh}
      head > u  -> {ll, {med, lm}, lh+1}
      true      -> {ll, {[head|med], lm+1}, lh}
    end
  end

end
