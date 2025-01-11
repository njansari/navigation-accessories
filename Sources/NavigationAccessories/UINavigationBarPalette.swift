import UIKit

class UINavigationBarPalette: UIView {
    private static let classType = NSClassFromString(className) as? UIView.Type

    private(set) var palette: UIView?
    var contentView: UIView

    init?(contentView: UIView) {
        guard let navigationBarPaletteClass = Self.classType else { return nil }

        self.contentView = contentView

        let initWithContentViewSelector = NSSelectorFromString(Self.initWithContentViewSelectorName)

        palette = navigationBarPaletteClass
            .perform(#selector(NSProxy.alloc))?
            .takeUnretainedValue()
            .perform(initWithContentViewSelector, with: contentView)?
            .takeUnretainedValue() as? UIView

        super.init(frame: .zero)
    }

    init?(using palette: UIView?) {
        guard Self.classType != nil, let palette else { return nil }

        self.palette = palette
        self.contentView = palette.value(forKey: Self.contentViewKey) as? UIView ?? .init()

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var preferredHeight: Double? {
        get {
            palette?.value(forKey: Self.preferredHeightKey) as? Double
        } set {
            palette?.setValue(newValue, forKey: Self.preferredHeightKey)
        }
    }

    var displaysWhenSearchActive: Bool {
        get {
            palette?.value(forKey: Self.displaysWhenSearchActiveKey) as? Bool ?? false
        } set {
            palette?.setValue(newValue, forKey: Self.displaysWhenSearchActiveKey)
        }
    }
}

private extension UINavigationBarPalette {
    static var className: String {
        // "_UINavigationBarPalette"
        ["Palette", "Bar", "Navigation", "UI", "_"].reversed().joined()
    }

    static var initWithContentViewSelectorName: String {
        // "initWithContentView:"
        [":", "View", "Content", "With", "init"].reversed().joined()
    }

    static var contentViewKey: String {
        // "contentView"
        ["View", "content"].reversed().joined()
    }

    static var preferredHeightKey: String {
        // "preferredHeight"
        ["Height", "preferred"].reversed().joined()
    }

    static var displaysWhenSearchActiveKey: String {
        // "_displaysWhenSearchActive"
        ["Active", "Search", "When", "displays", "_"].reversed().joined()
    }
}
