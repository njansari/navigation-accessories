import UIKit

extension UIBlurEffect {
    static func variableBlurEffect(radius: Double, maskImage: UIImage) -> UIBlurEffect? {
        let symbol = (@convention(c) (AnyClass, Selector, Double, UIImage) -> UIBlurEffect).self
        let selector = NSSelectorFromString(Self.variableBlurEffectSelectorName)

        guard UIBlurEffect.responds(to: selector) else { return nil }

        let implementation = UIBlurEffect.method(for: selector)
        let method = unsafeBitCast(implementation, to: symbol)

        return method(UIBlurEffect.self, selector, radius, maskImage)
    }
}

private extension UIBlurEffect {
    static var variableBlurEffectSelectorName: String {
        // "effectWithVariableBlurRadius:imageMask:"
        [":", "Mask", "image", ":", "Radius", "Blur", "Variable", "With", "effect"].reversed().joined()
    }
}
