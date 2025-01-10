import UIKit

public enum NavigationAccessoryUpdateReason {
    case added
    case modified
    case removed
}

public protocol NavigationAccessory: Hashable, Identifiable {
    var id: String { get }

    @MainActor func update(in viewController: UIViewController, reason: NavigationAccessoryUpdateReason)
}
