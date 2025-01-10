import SwiftUI

extension View {
    func navigationAccessoriesTarget() -> some View {
        backgroundPreferenceValue(NavigationAccessoriesKey.self) { value in
            NavigationAccessoriesView(
                weeTitle: value.weeTitle,
                accessoryView: value.accessoryView,
                bottomPalette: value.bottomPalette,
                titleView: value.titleView
            )
        }
    }
    
    nonisolated func navigationWeeTitle(_ title: String?) -> some View {
        transformPreference(NavigationAccessoriesKey.self) { value in
            value.weeTitle = .init(title: title)
        }
    }
    
    nonisolated func navigationLargeTitleAccessoryView<Content: View>(
        alignsToBaseline: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        transformPreference(NavigationAccessoriesKey.self) { value in
            value.accessoryView = .init(
                content: AnyView(content()),
                alignsToBaseline: alignsToBaseline
            )
        }
    }
    
    nonisolated func navigationBottomPalette<Content: View>(
        displaysWhenSearchActive: Bool = false,
        height: CGFloat? = nil,
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        transformPreference(NavigationAccessoriesKey.self) { value in
            value.bottomPalette = .init(
                content: AnyView(content()),
                displaysWhenSearchActive: displaysWhenSearchActive,
                frame: .init(height: height, alignment: alignment)
            )
        }
    }
    
    nonisolated func navigationTitleView<Content: View>(
        hidesStandardTitle: Bool = false,
        height: CGFloat? = nil,
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        transformPreference(NavigationAccessoriesKey.self) { value in
            value.titleView = .init(
                content: AnyView(content()),
                hidesStandardTitle: hidesStandardTitle,
                frame: .init(height: height, alignment: alignment)
            )
        }
    }
}

private struct NavigationAccessoriesKey: @preconcurrency PreferenceKey {
    @MainActor static let defaultValue = NavigationAccessories<AnyView, AnyView, AnyView>()

    static func reduce(value: inout Value, nextValue: () -> Value) {
        let newValue = nextValue()

        value.weeTitle = newValue.weeTitle ?? value.weeTitle
        value.accessoryView = newValue.accessoryView ?? value.accessoryView
        value.bottomPalette = newValue.bottomPalette ?? value.bottomPalette
        value.titleView = newValue.titleView ?? value.titleView
    }
}

private struct NavigationAccessories<A: View, B: View, T: View> {
    var weeTitle: WeeTitleValues? = nil
    var accessoryView: LargeTitleAccessoryViewValues<A>? = nil
    var bottomPalette: BottomPaletteValues<B>? = nil
    var titleView: TitleViewValues<T>? = nil
}

private struct WeeTitleValues {
    let title: String?
}

private struct LargeTitleAccessoryViewValues<Content: View> {
    let content: Content?
    let alignsToBaseline: Bool
}

private struct BottomPaletteValues<Content: View> {
    let content: Content?
    let displaysWhenSearchActive: Bool
    let frame: AccessoryFrame
}

private struct TitleViewValues<Content: View> {
    let content: Content?
    let hidesStandardTitle: Bool
    let frame: AccessoryFrame
}

private struct AccessoryFrame {
    let height: CGFloat?
    let alignment: Alignment
}

private struct NavigationAccessoriesView<A: View, B: View, T: View>: UIViewControllerRepresentable {
    let weeTitle: WeeTitleValues?
    let accessoryView: LargeTitleAccessoryViewValues<A>?
    let bottomPalette: BottomPaletteValues<B>?
    let titleView: TitleViewValues<T>?

    func updateNavigationAccessories(for navAccessoriesVC: NavigationAccessoriesViewController<A, B, T>) {
        navAccessoriesVC.weeTitleValues = weeTitle
        navAccessoriesVC.accessoryViewValues = accessoryView
        navAccessoriesVC.bottomPaletteValues = bottomPalette
        navAccessoriesVC.titleViewValues = titleView
    }

    func makeUIViewController(context: Context) -> NavigationAccessoriesViewController<A, B, T> {
        let navAccessoriesVC = NavigationAccessoriesViewController<A, B, T>()
        updateNavigationAccessories(for: navAccessoriesVC)

        return navAccessoriesVC
    }

    func updateUIViewController(_ navAccessoriesVC: NavigationAccessoriesViewController<A, B, T>, context: Context) {
        updateNavigationAccessories(for: navAccessoriesVC)
    }
}

private extension UIView {
    func activateConstraintsFromAlignment(_ alignment: Alignment, with otherView: UIView) {
        switch alignment.horizontal {
        case .leading:
            leadingAnchor.constraint(equalTo: otherView.leadingAnchor).isActive = true
        case .trailing:
            trailingAnchor.constraint(equalTo: otherView.trailingAnchor).isActive = true
        default:
            widthAnchor.constraint(equalTo: otherView.widthAnchor).isActive = true
            centerXAnchor.constraint(equalTo: otherView.centerXAnchor).isActive = true
        }

        switch alignment.vertical {
        case .top:
            topAnchor.constraint(equalTo: otherView.topAnchor).isActive = true
        case .bottom:
            bottomAnchor.constraint(equalTo: otherView.bottomAnchor).isActive = true
        default:
            heightAnchor.constraint(equalTo: otherView.heightAnchor).isActive = true
            centerYAnchor.constraint(equalTo: otherView.centerYAnchor).isActive = true
        }
    }
}

private class NavigationAccessoriesViewController<A: View, B: View, T: View>: UIViewController {
    var weeTitleValues: WeeTitleValues? {
        didSet { updateWeeTitle() }
    }

    var accessoryViewValues: LargeTitleAccessoryViewValues<A>? {
        didSet { updateAccessoryView() }
    }

    var bottomPaletteValues: BottomPaletteValues<B>? {
        didSet { updateBottomPalette() }
    }

    var titleViewValues: TitleViewValues<T>? {
        didSet { updateTitleView() }
    }

    private var accessoryViewHostingController: UIHostingController<A>?
    private var bottomPaletteHostingController: UIHostingController<B>?
    private var titleViewHostingController: UIHostingController<T>?

    var targetNavigationItem: UINavigationItem? {
        navigationController?.topViewController?.navigationItem
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        updateWeeTitle()
        updateAccessoryView()
        updateBottomPalette()
        updateTitleView()
    }

    private func updateWeeTitle() {
        guard let targetNavigationItem, let title = weeTitleValues?.title else { return }
        targetNavigationItem.weeTitle = title
    }

    private func updateAccessoryView() {
        guard let targetNavigationItem else { return }

        guard let accessoryViewValues, let content = accessoryViewValues.content else {
            accessoryViewHostingController = nil
            targetNavigationItem.largeTitleAccessoryView = nil
            return
        }

        guard accessoryViewHostingController == nil else { return }
        accessoryViewHostingController = UIHostingController(rootView: content)

        guard let contentView = accessoryViewHostingController?.view else { return }
        contentView.backgroundColor = nil

        targetNavigationItem.largeTitleAccessoryView = contentView
        targetNavigationItem.alignLargeTitleAccessoryViewToBaseline = accessoryViewValues.alignsToBaseline
    }

    private func updateBottomPalette() {
        guard let targetNavigationItem else { return }

        guard let bottomPaletteValues, let content = bottomPaletteValues.content else {
            bottomPaletteHostingController = nil
            targetNavigationItem.bottomPalette = nil
            return
        }

        if let bottomPaletteHostingController {
            bottomPaletteHostingController.rootView = content
        } else {
            bottomPaletteHostingController = UIHostingController(rootView: content)
        }

        guard let contentView = bottomPaletteHostingController?.view else { return }
        contentView.backgroundColor = nil

        let targetSize = CGSize(width: view.frame.width, height: UIView.layoutFittingCompressedSize.height)
        let viewHeight = bottomPaletteValues.frame.height ?? contentView.systemLayoutSizeFitting(targetSize).height

        contentView.translatesAutoresizingMaskIntoConstraints = false

        func setupPaletteContainer(_ containerView: UIView) {
            containerView.subviews.forEach { $0.removeFromSuperview() }
            containerView.addSubview(contentView)
            contentView.activateConstraintsFromAlignment(bottomPaletteValues.frame.alignment, with: containerView)
        }

        if let containerView = targetNavigationItem.bottomPaletteContentView {
            setupPaletteContainer(containerView)
        } else {
            if let navigationBarPaletteClass = NSClassFromString("_UINavigationBarPalette") as? UIView.Type {
                let initWithContentViewSelector = NSSelectorFromString("initWithContentView:")

                let containerView = UIView()
                setupPaletteContainer(containerView)

                let bottomPalette = navigationBarPaletteClass
                    .perform(#selector(NSProxy.alloc))?
                    .takeUnretainedValue()
                    .perform(initWithContentViewSelector, with: containerView)?
                    .takeUnretainedValue() as? UIView

                targetNavigationItem.bottomPalette = bottomPalette
            }
        }

        targetNavigationItem.preferredBottomPaletteHeight = viewHeight
        targetNavigationItem.displaysBottomPaletteWhenSearchActive = bottomPaletteValues.displaysWhenSearchActive
    }

    private func updateTitleView() {
        guard let targetNavigationItem else { return }

        guard let titleViewValues, let content = titleViewValues.content else {
            titleViewHostingController = nil
            targetNavigationItem.titleView = nil
            return
        }

        if let titleViewHostingController {
            titleViewHostingController.rootView = content
        } else {
            titleViewHostingController = UIHostingController(rootView: content)
        }

        guard let contentView = titleViewHostingController?.view else { return }
        contentView.backgroundColor = nil

        let targetSize = CGSize(width: view.frame.width, height: UIView.layoutFittingCompressedSize.height)
        let viewHeight = titleViewValues.frame.height ?? contentView.systemLayoutSizeFitting(targetSize).height

        contentView.translatesAutoresizingMaskIntoConstraints = false

        func setupTitleView(_ titleView: UIView) {
            titleView.subviews.forEach { $0.removeFromSuperview() }
            titleView.addSubview(contentView)
            contentView.activateConstraintsFromAlignment(titleViewValues.frame.alignment, with: titleView)

            let setHeightSelector = NSSelectorFromString("setHeight:")
            titleView.perform(setHeightSelector, with: viewHeight)

            titleView.setValue(titleViewValues.hidesStandardTitle, forKey: "hideStandardTitle")
        }

        if let titleViewClass = NSClassFromString("_UINavigationBarTitleView") as? UIView.Type {
            if let titleView = targetNavigationItem.titleView, titleView.isKind(of: titleViewClass) {
                setupTitleView(titleView)
            } else {
                let titleView = titleViewClass.init()
                setupTitleView(titleView)

                targetNavigationItem.titleView = titleView
            }
        }
    }
}

private extension UINavigationItem {
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

    var bottomPalette: UIView? {
        get {
            value(forKey: "_bottomPalette") as? UIView
        } set {
            let selector = NSSelectorFromString("_setBottomPalette:")
            perform(selector, with: newValue)
        }
    }

    var bottomPaletteContentView: UIView? {
        bottomPalette?.value(forKey: "contentView") as? UIView
    }

    var preferredBottomPaletteHeight: Double? {
        get {
            bottomPalette?.value(forKey: "preferredHeight") as? Double
        } set {
            bottomPalette?.setValue(newValue, forKey: "preferredHeight")
        }
    }

    var displaysBottomPaletteWhenSearchActive: Bool {
        get {
            bottomPalette?.value(forKey: "_displaysWhenSearchActive") as? Bool ?? false
        } set {
            bottomPalette?.setValue(newValue, forKey: "_displaysWhenSearchActive")
        }
    }
}
