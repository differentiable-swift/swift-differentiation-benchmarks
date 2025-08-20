import Benchmark
import Differentiation
import Foundation
import Randy

typealias DifferentiableCollection = Collection & Differentiable & InitializableFromSequence

let benchmarks: @Sendable () -> Void = {
    Benchmark.defaultConfiguration = .init(metrics: [.wallClock, .mallocCountTotal])

    var gen = UniformRandomNumberGenerator(seed: 0xC0FFEE)
    let distribution = RandomDistribution(.uniform(min: -1.0e40, max: 1.0e40))


    enum AutodiffPass: String {
        case regular
        case forward
        case reverse
        case complete
    }

    func setup<C: DifferentiableCollection>(_ collectionType: C.Type, count: Int) -> C where C.Element: RandomizableWithDistribution {
        return C(Array<C.Element>.random(count: count, in: distribution, using: &gen))
    }

    func bench<Input, Output>(regular fn: @escaping @differentiable(reverse) (Input) -> (Output)) -> (Benchmark, Input) -> () {
        return { benchmark, input in
            blackHole(fn(input))
        }
    }
    func bench<Input, Output>(forward fn: @escaping @differentiable(reverse) (Input) -> (Output)) -> (Benchmark, Input) -> () {
        return { benchmark, input in
            blackHole(valueWithPullback(at: input, of: fn))
        }
    }
    func bench<Input, Output>(reverse fn: @escaping @differentiable(reverse) (Input) -> (Output), seed: Output.TangentVector) -> (Benchmark, Input) -> () {
        return { benchmark, input in
            let pullback = valueWithPullback(at: input, of: fn).pullback
            benchmark.startMeasurement()
            blackHole(pullback(seed))
        }
    }
    func bench<Input, Output>(complete fn: @escaping @differentiable(reverse) (Input) -> (Output), seed: Output.TangentVector, scalingFactor: BenchmarkScalingFactor = .kilo) -> (Benchmark, Input) -> () {
        return { benchmark, input in
            var input = input
            // one round to trigger CoW
            var (value, pullback) = valueWithPullback(at: input, of: fn)
            let grad = pullback(seed)
            input.move(by: grad)

            benchmark.startMeasurement()
            for _ in 0..<scalingFactor.rawValue {
                var (value, pullback) = valueWithPullback(at: input, of: fn)
                let grad = pullback(seed)
                input.move(by: grad)
            }
            blackHole(input)
        }
    }

    func config(count: Int, pass: AutodiffPass, scaling: BenchmarkScalingFactor = .one) -> Benchmark.Configuration {
        return .init(tags: [
            "count": "\(count)",
            "pass": pass.rawValue,
        ])
    }

    let counts = [64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768]
    for count in counts {
        // MARK: map-reduce
        Benchmark("<Float32>map(sin).reduce(0,+)",
            configuration: config(count: count, pass: .regular), closure: bench(regular: { $0.mapReduce({ sin($0) }, Float32.zero, +) }                    ), setup: { setup(Array<Float32>.self, count: count) })
        Benchmark("<Float32>map(sin).reduce(0,+)",
            configuration: config(count: count, pass: .forward), closure: bench(forward: { $0.mapReduce({ sin($0) }, Float32.zero, +) }                    ), setup: { setup(Array<Float32>.self, count: count) })
        Benchmark("<Float32>map(sin).reduce(0,+)",
            configuration: config(count: count, pass: .reverse), closure: bench(reverse: { $0.mapReduce({ sin($0) }, Float32.zero, +) }, seed: Float32(1.0)), setup: { setup(Array<Float32>.self, count: count) })

        // MARK: meanSquaredError
        let target = setup(Array<Float32>.self, count: count)

        Benchmark("<Float32>meanSquaredError",
            configuration: config(count: count, pass: .regular), closure: bench(regular: { $0.meanSquaredError(to: target) }),                    setup: { setup(Array<Float32>.self, count: count) })
        Benchmark("<Float32>meanSquaredError",
            configuration: config(count: count, pass: .forward), closure: bench(forward: { $0.meanSquaredError(to: target) }),                    setup: { setup(Array<Float32>.self, count: count) })
        Benchmark("<Float32>meanSquaredError",
            configuration: config(count: count, pass: .reverse), closure: bench(reverse: { $0.meanSquaredError(to: target) }, seed: Float32(1.0)), setup: { setup(Array<Float32>.self, count: count) })
    }
}
