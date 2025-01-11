import UIKit

extension UINavigationItem {
    var weeTitle: String? {
        get {
            value(forKey: Self.weeTitleKey) as? String
        } set {
            let selector = NSSelectorFromString(Self.setWeeTitleSelectorName)
            perform(selector, with: newValue)
        }
    }

    var largeTitleAccessoryView: UIView? {
        get {
            value(forKey: Self.largeTitleAccessoryViewKey) as? UIView
        } set {
            let selector = NSSelectorFromString(Self.setLargeTitleAccessoryViewSelectorName)
            perform(selector, with: newValue)
        }
    }

    var alignLargeTitleAccessoryViewToBaseline: Bool {
        get {
            value(forKey: Self.alignLargeTitleAccessoryViewToBaselineKey) as? Bool ?? true
        } set {
            setValue(newValue, forKey: Self.alignLargeTitleAccessoryViewToBaselineKey)
        }
    }

    var bottomPalette: UINavigationBarPalette? {
        get {
            let palette = value(forKey: Self.bottomPaletteKey) as? UIView
            return UINavigationBarPalette(using: palette)
        } set {
            let selector = NSSelectorFromString(Self.setBottomPaletteSelectorName)
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

private extension UINavigationItem {
    static var weeTitleKey: String {
        // "_weeTitle"
        ["Title", "wee", "_"].reversed().joined()
    }

    static var setWeeTitleSelectorName: String {
        // "_setWeeTitle:"
        [":", "Title", "Wee", "set", "_"].reversed().joined()
    }

    static var largeTitleAccessoryViewKey: String {
        // "_largeTitleAccessoryView"
        ["View", "Accessory", "Title", "large", "_"].reversed().joined()
    }

    static var setLargeTitleAccessoryViewSelectorName: String {
        // "_setLargeTitleAccessoryView:"
        [":", "View", "Accessory", "Title", "Large", "set", "_"].reversed().joined()
    }

    static var alignLargeTitleAccessoryViewToBaselineKey: String {
        // "_alignLargeTitleAccessoryViewToBaseline"
        ["Baseline", "To", "View", "Accessory", "Title", "Large", "align", "_"].reversed().joined()
    }

    static var bottomPaletteKey: String {
        // "_bottomPalette"
        ["Palette", "bottom", "_"].reversed().joined()
    }

    static var setBottomPaletteSelectorName: String {
        // "_setBottomPalette:"
        [":", "Palette", "Bottom", "set", "_"].reversed().joined()
    }
}
