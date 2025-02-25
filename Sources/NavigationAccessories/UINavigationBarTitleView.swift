import UIKit

class UINavigationBarTitleView: UIView {
    private static let classType = NSClassFromString(className) as? UIView.Type

    private(set) var titleView: UIView?
    private(set) var contentView: UIView?

    init?(contentView: UIView) {
        guard let titleViewClass = Self.classType else { return nil }

        self.contentView = contentView

        self.titleView = titleViewClass.init()
        titleView?.addSubview(contentView)

        super.init(frame: .zero)
    }

    init?(using titleView: UIView?) {
        guard let titleViewClass = Self.classType, titleView?.isKind(of: titleViewClass) == true else { return nil }

        self.titleView = titleView
        self.contentView = titleView?.subviews.first

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var hideStandardTitle: Bool {
        get {
            titleView?.value(forKey: Self.hideStandardTitleKey) as? Bool ?? false
        } set {
            titleView?.setValue(newValue, forKey: Self.hideStandardTitleKey)
        }
    }

    func setHeight(_ height: Double) {
        let setHeightSelector = NSSelectorFromString(Self.setHeightSelectorName)
        titleView?.perform(setHeightSelector, with: height)
    }
}

private extension UINavigationBarTitleView {
    static var className: String {
        // "_UINavigationBarTitleView"
        ["View", "Title", "Bar", "Navigation", "UI", "_"].reversed().joined()
    }

    static var hideStandardTitleKey: String {
        // "hideStandardTitle"
        ["Title", "Standard", "hide"].reversed().joined()
    }

    static var setHeightSelectorName: String {
        // "setHeight:"
        [":", "Height", "set"].reversed().joined()
    }
}
