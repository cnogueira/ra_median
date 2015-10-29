defmodule RaMedian do

  def main(args) do
    :random.seed(:os.timestamp)
    case OptionParser.parse(args) do
      {[],[],[]} -> benchmark(10, 1_000_000)
      {[i: i, s: s],_,_} -> benchmark((Integer.parse(i) |> elem(0)), (Integer.parse(s) |> elem(0)))
      {[i: i] ,_ ,_}     -> benchmark((Integer.parse(i) |> elem(0)), 1_000_000)
      {[s: s],_,_}       -> benchmark(10, (Integer.parse(s) |> elem(0)))
      _                  -> show_help
    end
  end

  defp benchmark(iterations, vector_size) do
    IO.puts "Initializing benchmark with sample vectors of Size: #{vector_size}"

    results_list = for i <- 1..iterations do
      IO.write "\r                          " # erase the current line
      IO.write "\rIteration #{i} out of #{iterations}"
      unit_benchmark(vector_size)
    end
    IO.puts "\r                                  "
    results = List.foldl(results_list, {0,0,0}, fn({qs,mm,rs}, {a_qs,a_mm,a_rs}) -> {qs + a_qs, mm + a_mm, rs + a_rs} end)

    IO.puts "Avg. elapsed time by the QS algorithm: #{elem(results, 0)/iterations} sec."
    IO.puts "Avg. elapsed time by the MM algorithm: #{elem(results, 1)/iterations} sec."
    IO.puts "Avg. elapsed time by the RS algorithm: #{elem(results, 2)/iterations} sec."
    IO.puts "\nBenchmark took #{elem(results, 0)+elem(results, 1)+elem(results, 2)} sec."
  end



  # Given an input vector size, randomly generates a list of 'size'
  # elements between [0..size) and executes the 'median' function
  # of the QS, MoM, RS modules and returns its execution times
  defp unit_benchmark(vector_size) do
    input = for _ <- 0..vector_size, do: :random.uniform(2*vector_size)-1
    elapsed_qs = elem(:timer.tc(fn -> QS.median(input) end), 0)/1_000_000
    elapsed_mm = elem(:timer.tc(fn -> MoM.median(input) end), 0)/1_000_000
    elapsed_rs = elem(:timer.tc(fn -> RS.median(input) end), 0)/1_000_000
    {elapsed_qs, elapsed_mm, elapsed_rs}
  end

  defp show_help do
    IO.puts "Usage: '.\\ra_median [--i Iterations] [--s Size]'"
    IO.puts "Options:"
    IO.puts "\t--i N: perform N iterations of the benchmark (default: 10)"
    IO.puts "\t--s N: size of the imput vector for the benchmark (default: 1M)"
  end

end
