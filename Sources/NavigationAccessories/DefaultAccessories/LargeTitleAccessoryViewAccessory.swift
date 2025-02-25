import SwiftUI

struct LargeTitleAccessoryViewAccessory<Content: Hashable & View>: NavigationAccessory {
    let id = "LargeTitleAccessoryViewAccessory"

    let alignsToBaseline: Bool
    let content: Content

    func update(in viewController: UIViewController, reason: NavigationAccessoryUpdateReason) {
        let navigationItem = viewController.navigationItem

        switch reason {
        case .added:
            let contentView = _UIHostingView(rootView: content)
            contentView.backgroundColor = nil
            navigationItem.largeTitleAccessoryView = contentView

            navigationItem.alignLargeTitleAccessoryViewToBaseline = alignsToBaseline

        case .modified:
            if let contentView = navigationItem.largeTitleAccessoryView as? _UIHostingView<Content> {
                contentView.rootView = content
            }

            navigationItem.alignLargeTitleAccessoryViewToBaseline = alignsToBaseline

        case .removed:
            navigationItem.largeTitleAccessoryView = nil
        }
    }
}
