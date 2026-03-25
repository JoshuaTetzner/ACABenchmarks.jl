using DelimitedFiles
using Plots

function load_benchmark_csv(csv_path::AbstractString)
    if !isfile(csv_path)
        error("CSV file not found: $(csv_path)")
    end

    data, _ = readdlm(csv_path, ',', header=true)
    if size(data, 2) < 2
        error("Expected at least 2 columns: threads,time_seconds")
    end

    threads = Int.(data[:, 1])
    times = Float64.(data[:, 2])

    perm = sortperm(threads)
    return threads[perm], times[perm]
end

function plot_benchmark(csv_path::AbstractString; output_path::AbstractString="thread_benchmark.png")
    threads, times = load_benchmark_csv(csv_path)

    p = plot(
        threads,
        times;
        marker=:circle,
        linewidth=2,
        xlabel="Threads",
        ylabel="Time (s)",
        title="Benchmark: Threads vs Time",
        legend=false,
        xticks=threads,
    )

    savefig(p, output_path)
    println("Saved plot to: ", output_path)
end

csv_path = joinpath(@__DIR__, "..", "results", "thread_benchmark.csv")
plot_path = joinpath(@__DIR__, "..", "results", "thread_benchmark.png")
plot_benchmark(csv_path; output_path=plot_path)