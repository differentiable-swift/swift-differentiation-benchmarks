import Benchmark

let benchmarks: @Sendable () -> Void = {
    let durations = [20, 40, 60, 80]
    let resolutions = [10, 20, 30, 40]
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
