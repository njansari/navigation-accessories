import SwiftUI

struct LargeTitleAccessory<Content: Hashable & View>: NavigationAccessory {
    let id = "LargeTitleAccessory"

    let alignsToBaseline: Bool
    let content: Content

    func update(in viewController: UIViewController, reason: NavigationAccessoryUpdateReason) {
        let navigationItem = viewController.navigationController?.topViewController?.navigationItem

        switch reason {
        case .added:
            let hostingController = UIHostingController(rootView: content)
            viewController.hostingControllers[id] = hostingController

            if let contentView = hostingController.view {
                contentView.backgroundColor = nil
                navigationItem?.largeTitleAccessoryView = contentView
            }

        case .modified:
            let hostingController = viewController.hostingControllers[id] as? UIHostingController<Content>
            hostingController?.rootView = content

            if let contentView = hostingController?.view {
                contentView.backgroundColor = nil
                navigationItem?.largeTitleAccessoryView = contentView
            }

        case .removed:
            viewController.hostingControllers[id] = nil
            navigationItem?.largeTitleAccessoryView	= nil
        }

        navigationItem?.alignLargeTitleAccessoryViewToBaseline = alignsToBaseline
    }
}
