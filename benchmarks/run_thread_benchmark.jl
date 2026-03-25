thread_counts = collect(1:16)
csv_path = joinpath(@__DIR__, "..", "results", "thread_benchmark.csv")
child_script = joinpath(@__DIR__, "run_single_benchmark.jl")
project_path = dirname(dirname(@__DIR__))

mkpath(dirname(csv_path))

open(csv_path, "w") do io
	println(io, "threads,time_seconds")
	flush(io)

	for nthreads in thread_counts
		cmd = `julia --threads=$(nthreads) --project=$(project_path) $(child_script)`
		try
			output = read(cmd, String)
			result_line = strip(output)
			println(io, result_line)
			flush(io)
			println(result_line)
		catch e
			println("Error running threads=$(nthreads): ", e)
		end
	end
end

println("Benchmark complete. Results saved to: ", csv_path)