import Differentiation

extension Array where Element: Differentiable {
    @inlinable
    @differentiable(reverse, wrt: self)
    public func mapReduce<T: Differentiable, R: Differentiable>(
        _ transform:  @differentiable(reverse) (Element) -> T,
        _ initialResult: R,
        _ accumulate: @differentiable(reverse) (R, T) -> R
    ) -> R {
        return self.differentiableMap(transform).differentiableReduce(initialResult, accumulate)
    }
}

// Add more collections
// extension SparseArray where Element: Differentiable {
// ...
// }

