import UIKit

class UINavigationBarTitleView: UIView {
    static let classType = NSClassFromString("_UINavigationBarTitleView") as? UIView.Type

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
            titleView?.value(forKey: "hideStandardTitle") as? Bool ?? false
        } set {
            titleView?.setValue(newValue, forKey: "hideStandardTitle")
        }
    }

    func setHeight(_ height: Double) {
        let setHeightSelector = NSSelectorFromString("setHeight:")
        titleView?.perform(setHeightSelector, with: height)
    }

    override var subviews: [UIView] {
        titleView?.subviews ?? super.subviews
    }

    override func addSubview(_ view: UIView) {
        titleView?.addSubview(view)
    }
}
