defmodule QSTest do
  use ExUnit.Case
  doctest RaMedian

  test "find median of ordered even vector" do
    a = for i <- 1..100, do: i
    assert QS.median(a) == 50
  end

  test "find median of ordered odd vector" do
    a = for i <- 0..100, do: i
    assert QS.median(a) == 50
  end

  test "find median of randomized vector" do
    :random.seed(:os.timestamp)
    a = for _ <- 0..100, do: :random.uniform(200)
    assert QS.median(a) == elem(Enum.fetch(Enum.sort(a), 50), 1)
  end

end
