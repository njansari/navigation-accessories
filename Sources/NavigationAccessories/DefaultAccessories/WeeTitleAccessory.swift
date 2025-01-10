import UIKit

struct WeeTitleAccessory: NavigationAccessory {
    let id = "WeeTitleAccessory"
    let title: String?

    func update(in viewController: UIViewController, reason: NavigationAccessoryUpdateReason) {
        viewController.navigationController?.topViewController?.navigationItem.weeTitle = title
    }
}
