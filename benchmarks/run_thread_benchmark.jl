using OhMyThreads: @set, @tasks, DynamicScheduler, SerialScheduler, StaticScheduler
using BenchmarkTools: @belapsed


function multithread_func(y::AbstractVector, x::AbstractVector; scheduler=SerialScheduler())

	@tasks for i in eachindex(x, y)
		@set scheduler = scheduler
		y[i] = x[i]^2
	end
end

len = 4_000_000_000
x = rand(len)
y = similar(x)
thread_counts = collect(1:16)

csv_path = joinpath(@__DIR__, "..", "results", "thread_benchmark.csv")
mkpath(dirname(csv_path))
open(csv_path, "w") do io
	println(io, "threads,time_seconds")
	flush(io)

	for nchunks in thread_counts
		curr_scheduler = StaticScheduler(nchunks=nchunks)
		t = @belapsed multithread_func($y, $x; scheduler=$curr_scheduler)
		println(io, string(nchunks, ",", t))
		flush(io)

		println("threads=", nchunks, " elapsed time (s): ", t)
	end
end