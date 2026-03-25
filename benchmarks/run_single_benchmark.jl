using BenchmarkTools: @belapsed
using H2Trees
using StaticArrays
using AdaptiveCrossApproximation
using LinearAlgebra
using OhMyThreads: StaticScheduler

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

nthreads = Base.Threads.nthreads()
scheduler = StaticScheduler(nchunks=nthreads)

t = @belapsed AdaptiveCrossApproximation.HMatrix($fct, $pts, $pts, $tree; scheduler=$scheduler)

println(string(nthreads, ",", t))
