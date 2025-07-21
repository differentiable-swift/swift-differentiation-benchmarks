import _Differentiation

// extension Array where Element: Differentiable {
//     @differentiable(reverse, wrt: self)
//     @inlinable
//     func appendingMap<T>(_ transform: (Element) -> T) -> [T] {
//         var result: [T] = []
//         for element in self {
//             result.append(transform(element))
//         }
//         return result
//     }
// }
