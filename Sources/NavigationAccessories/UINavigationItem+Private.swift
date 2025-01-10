import UIKit

extension UINavigationItem {
    var weeTitle: String? {
        get {
            value(forKey: "_weeTitle") as? String
        } set {
            let selector = NSSelectorFromString("_setWeeTitle:")
            perform(selector, with: newValue)
        }
    }

    var largeTitleAccessoryView: UIView? {
        get {
            value(forKey: "_largeTitleAccessoryView") as? UIView
        } set {
            let selector = NSSelectorFromString("_setLargeTitleAccessoryView:")
            perform(selector, with: newValue)
        }
    }

    var alignLargeTitleAccessoryViewToBaseline: Bool {
        get {
            value(forKey: "_alignLargeTitleAccessoryViewToBaseline") as? Bool ?? true
        } set {
            setValue(newValue, forKey: "_alignLargeTitleAccessoryViewToBaseline")
        }
    }

    var bottomPalette: UINavigationBarPalette? {
        get {
            let palette = value(forKey: "_bottomPalette") as? UIView
            return UINavigationBarPalette(using: palette)
        } set {
            let selector = NSSelectorFromString("_setBottomPalette:")
            perform(selector, with: newValue?.palette)
        }
    }

    var tallTitleView: UINavigationBarTitleView? {
        get {
            UINavigationBarTitleView(using: titleView)
        } set {
            titleView = newValue?.titleView
        }
    }
}
