import Differentiation

// XXX: cannot be made generic because `SignedNumeric` etc protocols cannot be extended to be differentiable as of now
extension Array where Element == Float32 {
    @inlinable
    @differentiable(reverse, wrt: self)
    func meanSquaredError(to target: [Float32]) -> Float32 {
        // precondition(self.count == target.count)
        var mse: Float32 = 0
        for i in 0..<withoutDerivative(at: self.count) {
            let d = self[i] - target[i]
            mse += d*d
        }
        return mse
    }
}
extension Array where Element == Float64 {
    @inlinable
    @differentiable(reverse, wrt: self)
    func meanSquaredError(to target: [Float64]) -> Float64 {
        // precondition(self.count == target.count)
        var mse: Float64 = 0
        for i in 0..<withoutDerivative(at: self.count) {
            let d = self[i] - target[i]
            mse += d*d
        }
        return mse
    }
}


// extension SparseArray where Element == Float64 {
// ...
//}
