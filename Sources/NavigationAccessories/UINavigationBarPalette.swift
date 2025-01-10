import UIKit

class UINavigationBarPalette: UIView {
    static let classType = NSClassFromString("_UINavigationBarPalette") as? UIView.Type

    private(set) var palette: UIView?
    var contentView: UIView

    init?(contentView: UIView) {
        guard let navigationBarPaletteClass = Self.classType else { return nil }

        self.contentView = contentView

        let initWithContentViewSelector = NSSelectorFromString("initWithContentView:")

        palette = navigationBarPaletteClass
            .perform(#selector(NSProxy.alloc))?
            .takeUnretainedValue()
            .perform(initWithContentViewSelector, with: contentView)?
            .takeUnretainedValue() as? UIView

        super.init(frame: .zero)
    }

    init?(using palette: UIView?) {
        guard Self.classType != nil else { return nil }

        self.palette = palette
        self.contentView = palette?.value(forKey: "contentView") as? UIView ?? .init()

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var preferredHeight: Double? {
        get {
            palette?.value(forKey: "preferredHeight") as? Double
        } set {
            palette?.setValue(newValue, forKey: "preferredHeight")
        }
    }

    var displaysWhenSearchActive: Bool {
        get {
            palette?.value(forKey: "_displaysWhenSearchActive") as? Bool ?? false
        } set {
            palette?.setValue(newValue, forKey: "_displaysWhenSearchActive")
        }
    }
}
