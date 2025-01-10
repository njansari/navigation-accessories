import SwiftUI

struct NavigationAccessoriesView: UIViewControllerRepresentable {
    let accessories: Accessories

    func makeUIViewController(context: Context) -> NavigationAccessoriesViewController {
        let viewController = NavigationAccessoriesViewController()
        viewController.updateAccessories(with: accessories)

        return viewController
    }

    func updateUIViewController(_ uiViewController: NavigationAccessoriesViewController, context: Context) {
        uiViewController.updateAccessories(with: accessories)
    }
}
