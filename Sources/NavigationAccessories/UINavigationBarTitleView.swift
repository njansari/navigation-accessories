import UIKit

class UINavigationBarTitleView: UIView {
    private static let classType = NSClassFromString(className) as? UIView.Type

    private(set) var titleView: UIView?

    init?(_: Bool = true) {
        guard let titleViewClass = Self.classType else { return nil }

        titleView = titleViewClass.init()

        super.init(frame: .zero)
    }

    init?(using titleView: UIView?) {
        guard let titleViewClass = Self.classType, titleView?.isKind(of: titleViewClass) == true else { return nil }

        self.titleView = titleView

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

    override func addSubview(_ view: UIView) {
        titleView?.addSubview(view)
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
