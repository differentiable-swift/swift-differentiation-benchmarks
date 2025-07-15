import Benchmark

let benchmarks: @Sendable () -> Void = {
    let durations = [10, 25, 50, 75]
    let resolutions = [20, 40, 50, 60, 80]
    for duration in durations {
        for resolution in resolutions {
            Benchmark(
                "ShallowWaterPDE",
                configuration: .init(
                    metrics: [.wallClock, .mallocCountTotal],
                    tags: [
                        "resolution": "\(resolution)",
                        "duration": "\(duration)",
                    ],
                    maxDuration: .seconds(300),
                    maxIterations: 20
                )
            ) { benchmark in
                let iterations = 10
                let target = Array2DStorage<Float>.loadTarget(target: Resources.swiftLogo.url, resolution: resolution)
                
                benchmark.startMeasurement()
                let optimizedInitialConditions = Solution.optimization(
                    target: target,
                    resolution: resolution,
                    duration: duration,
                    iterations: iterations
                )
                benchmark.stopMeasurement()
                
                blackHole(optimizedInitialConditions)
            }
        }
    }
}
