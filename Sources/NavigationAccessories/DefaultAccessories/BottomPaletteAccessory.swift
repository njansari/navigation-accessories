import SwiftUI

struct BottomPaletteAccessory<Content: Hashable & View>: NavigationAccessory {
    let id = "BottomPaletteAccessory"

    let displaysWhenSearchActive: Bool
    let height: CGFloat?
    let content: Content

    func update(in viewController: UIViewController, reason: NavigationAccessoryUpdateReason) {
        let navigationItem = viewController.navigationController?.topViewController?.navigationItem

        switch reason {
        case .added:
            let hostingController = UIHostingController(rootView: content)
            viewController.hostingControllers[id] = hostingController

            if let contentView = hostingController.view {
                contentView.backgroundColor = nil

                let targetSize = CGSize(
                    width: viewController.view.frame.width,
                    height: UIView.layoutFittingCompressedSize.height
                )

                let viewHeight = height ?? contentView.systemLayoutSizeFitting(targetSize).height

                let palette = UINavigationBarPalette(contentView: contentView)
                palette?.displaysWhenSearchActive = displaysWhenSearchActive
                palette?.preferredHeight = viewHeight

                navigationItem?.bottomPalette = palette
            }

        case .modified:
            let hostingController = viewController.hostingControllers[id] as? UIHostingController<Content>
            hostingController?.rootView = content

            if let contentView = hostingController?.view {
                let targetSize = CGSize(
                    width: viewController.view.frame.width,
                    height: UIView.layoutFittingCompressedSize.height
                )

                let viewHeight = height ?? contentView.systemLayoutSizeFitting(targetSize).height

                navigationItem?.bottomPalette?.preferredHeight = viewHeight
            }

            navigationItem?.bottomPalette?.displaysWhenSearchActive = displaysWhenSearchActive

        case .removed:
            navigationItem?.bottomPalette = nil
            viewController.hostingControllers[id] = nil
        }
    }
}
