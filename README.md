# swift-differentiation-benchmarks
This repository serves as a suite of benchmarks for the [Differentiable Swift](https://github.com/differentiable-swift#meet-differentiable-swift) language feature.

The CI tracks benchmarks for the following Swift versions
- [6.0.3](https://github.com/swiftlang/swift-docker/blob/f44060cdf224436060d2df98a5c3f63f2600de63/6.0/ubuntu/24.04/Dockerfile)
- [6.1.0](https://github.com/swiftlang/swift-docker/blob/fad056fa5f65f926323f0ff61129cb4e6b1eec11/6.1/ubuntu/24.04/Dockerfile)
- [nightly-main](https://hub.docker.com/layers/swiftlang/swift/nightly-main/images/sha256-3579d03b01a579f477c4119c2359452f774aec843861f384ab1a01cd2af87891)
- [nighly-6.2](https://hub.docker.com/layers/swiftlang/swift/nightly-6.2-noble/images/sha256-6383e8f65855b17bfc511446f1dba35405a55d23fd1982576757a84127c55f11)


## Overview
Currently the following benchmarks can be found in this repository
- [Language Coverage](Benchmarks/LanguageCoverage)
- [Shallow Water PDE](Benchmarks/ShallowWaterPDE)
- [Building Simulation](Benchmarks/BuildingSimulation)

## Differentiable Swift
The goal of the Differentiable Swift language feature is to provide first-class, language-integrated support for differentiable programming, making Swift the first general-purpose, statically typed programming language to have automatic differentiation built in. Originally developed as part of the [Swift for TensorFlow](https://github.com/tensorflow/swift) project, teams at [PassiveLogic](https://passivelogic.com) and elsewhere are currently working on it. Differentiable Swift is purely a language feature and isn't tied to any specific machine learning framework or platform.
To find out more, have a look at our library [differentiable-swift]() or our other [repositories](https://github.com/differentiable-swift).

## Contributing
If you run into something that's broken please file an issue! If you have code that reproduces broken behaviour add it to the issue so that we can more easily debug or help with the problem you're running into. 

## License
This library is released under the Apache 2.0 license. See [LICENSE](https://github.com/differentiable-swift/swift-differentiation/blob/main/LICENSE) for details.
