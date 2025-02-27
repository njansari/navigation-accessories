import UIKit

struct WeeTitleAccessory: NavigationAccessory {
    let id = "WeeTitleAccessory"
    let title: String

    func update(in viewController: UIViewController, reason: NavigationAccessoryUpdateReason) {
        switch reason {
        case .added, .modified:
            viewController.navigationItem.weeTitle = title
        case .removed:
            viewController.navigationItem.weeTitle = nil
        }
    }
}
