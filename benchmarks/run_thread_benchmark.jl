using OhMyThreads: @set, @tasks, DynamicScheduler, SerialScheduler, StaticScheduler
using BenchmarkTools: @belapsed
using H2Trees
using StaticArrays
using AdaptiveCrossApproximation
using LinearAlgebra
using Test


struct myfct end
Base.eltype(::myfct) = Float64
function (::myfct)(x, y)
    if x == y
        return 0.0
    else
        return inv(norm(x - y))
    end
end
fct = myfct()

dim = 25000
pts = [@SVector rand(3) for i in 1:dim]
tree = TwoNTree(pts, pts, 1 / 2^10; minvaluestest=100, minvaluestrial=100)

thread_counts = collect(1:16)

csv_path = joinpath(@__DIR__, "..", "results", "thread_benchmark.csv")
mkpath(dirname(csv_path))
open(csv_path, "w") do io
	println(io, "threads,time_seconds")
	flush(io)

	for nchunks in thread_counts
		curr_scheduler = StaticScheduler(nchunks=nchunks)
		t = @belapsed AdaptiveCrossApproximation.HMatrix($fct, $pts, $pts, $tree; scheduler=$curr_scheduler)
		println(io, string(nchunks, ",", t))
		flush(io)

		println("threads=", nchunks, " elapsed time (s): ", t)
	end
end