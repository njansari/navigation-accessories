import SwiftUI

struct TopPaletteAccessory<Content: Hashable & View>: NavigationAccessory {
    let id = "TopPaletteAccessory"

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

            navigationItem.topPalette = palette

        case .modified:
            if let contentView = navigationItem.topPalette?.contentView as? _UIHostingView<Content> {
                contentView.rootView = content

                let targetSize = CGSize(
                    width: viewController.view.frame.width,
                    height: UIView.layoutFittingCompressedSize.height
                )

                let viewHeight = height ?? contentView.systemLayoutSizeFitting(targetSize).height
                navigationItem.topPalette?.preferredHeight = viewHeight
            }

            navigationItem.topPalette?.displaysWhenSearchActive = displaysWhenSearchActive

        case .removed:
            navigationItem.topPalette = nil
        }
    }
}
