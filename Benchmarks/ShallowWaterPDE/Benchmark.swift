import Benchmark

let benchmarks: @Sendable () -> Void = {
    let iterationsList = [5, 10, 15, 20, 25]
    let resolutions = [10, 20, 30, 40, 50]
    for iterations in iterationsList {
        for resolution in resolutions {
            Benchmark(
                "ShallowWaterPDE",
                configuration: .init(
                    metrics: [.wallClock, .mallocCountTotal],
                    tags: [
                        "iterations": "\(iterations)",
                        "resolution": "\(resolution)",
                    ],
                    maxDuration: .seconds(300),
                    maxIterations: 20
                )
            ) { benchmark in
                let duration = 10
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
