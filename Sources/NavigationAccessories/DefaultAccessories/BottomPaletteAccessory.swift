import SwiftUI

struct BottomPaletteAccessory<Content: Hashable & View>: NavigationAccessory {
    let id = "BottomPaletteAccessory"

    let displaysWhenSearchActive: Bool
    let height: CGFloat?
    let content: Content

    func update(in viewController: UIViewController, reason: NavigationAccessoryUpdateReason) {
        let navigationItem = viewController.navigationItem

        switch reason {
        case .added:
            let contentView = _UIHostingView(rootView: content)
            contentView.backgroundColor = nil

            let targetSize = CGSize(
                width: viewController.view.frame.width,
                height: UIView.layoutFittingCompressedSize.height
            )

            let viewHeight = height ?? contentView.systemLayoutSizeFitting(targetSize).height

            let palette = UINavigationBarPalette(contentView: contentView)
            palette?.displaysWhenSearchActive = displaysWhenSearchActive
            palette?.preferredHeight = viewHeight

            navigationItem.bottomPalette = palette

        case .modified:
            if let contentView = navigationItem.bottomPalette?.contentView as? _UIHostingView<Content> {
                contentView.rootView = content

                let targetSize = CGSize(
                    width: viewController.view.frame.width,
                    height: UIView.layoutFittingCompressedSize.height
                )

                let viewHeight = height ?? contentView.systemLayoutSizeFitting(targetSize).height
                navigationItem.bottomPalette?.preferredHeight = viewHeight
            }

            navigationItem.bottomPalette?.displaysWhenSearchActive = displaysWhenSearchActive

        case .removed:
            navigationItem.bottomPalette = nil
        }
    }
}
