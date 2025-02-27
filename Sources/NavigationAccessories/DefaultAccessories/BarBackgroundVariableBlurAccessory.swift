import UIKit

struct BarBackgroundVariableBlurAccessory: NavigationAccessory {
    let id = "BarBackgroundVariableBlurAccessory"

    let radius: Double

    func update(in viewController: UIViewController, reason: NavigationAccessoryUpdateReason) {
        let appearance = viewController.navigationController?.navigationBar.standardAppearance

        switch reason {
        case .added, .modified:
            appearance?.backgroundEffect = .variableBlurEffect(radius: radius, maskImage: .init(resource: .navigationBarBackdropMask))
            appearance?.shadowColor = .clear
        case .removed:
            appearance?.backgroundEffect = nil
        }
    }
}
