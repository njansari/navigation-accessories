import SwiftUI

struct LargeTitleAccessoryViewAccessory<Content: Hashable & View>: NavigationAccessory {
    let id = "LargeTitleAccessoryViewAccessory"

    let alignsToBaseline: Bool
    let content: Content

    func update(in viewController: UIViewController, reason: NavigationAccessoryUpdateReason) {
        let navigationItem = viewController.navigationItem

        switch reason {
        case .added:
            let hostingController = UIHostingController(rootView: content)
            viewController[hostingControllerForID: id] = hostingController

            if let contentView = hostingController.view {
                contentView.backgroundColor = nil
                navigationItem.largeTitleAccessoryView = contentView
            }

            navigationItem.alignLargeTitleAccessoryViewToBaseline = alignsToBaseline

        case .modified:
            let hostingController: UIHostingController<Content>? = viewController[hostingControllerForID: id]
            hostingController?.rootView = content

            navigationItem.alignLargeTitleAccessoryViewToBaseline = alignsToBaseline

        case .removed:
            navigationItem.largeTitleAccessoryView = nil
            viewController[hostingControllerForID: id, withContentType: Content.self] = nil
        }
    }
}
