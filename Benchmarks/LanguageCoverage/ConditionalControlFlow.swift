import _Differentiation

public protocol Real: FloatingPoint & Differentiable where Self.TangentVector : FloatingPoint & Differentiable {}

public struct ReLU<T: Real> {
    let pivot: T

    public init(_ pivot: T) { self.pivot = pivot }

    @differentiable(reverse, wrt: x)
    public func callAsFunction(_ x: T) -> T {
        let pivot = withoutDerivative(at: self.pivot)
        if x < pivot {
            return .zero
        }
        return x.subtract(pivot)
    }
}

public extension Real {
    @differentiable(reverse)
    @inlinable
    func subtract(_ y: Self) -> Self {
        return self - y
    }

    @derivative(of: subtract)
    @inlinable
    func _vjpSubtract1(_ y: Self) -> (value: Self, pullback: (Self.TangentVector) -> (Self.TangentVector, Self.TangentVector)) {
        return (
            value: self.subtract(y),
            pullback: { v in
                return (v, -v)
            }
        )
    }
}


extension Float: Real {}
extension Double: Real {}
