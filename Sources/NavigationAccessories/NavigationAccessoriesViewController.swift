import SwiftUI

class NavigationAccessoriesViewController: UIViewController {
    private var accessories: Accessories = []
    private var hasLoaded = false

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        guard !hasLoaded, let parent else { return }

        for accessory in accessories {
            accessory.update(in: parent, reason: .added)
        }

        hasLoaded = true
    }

    func updateAccessories(with newValue: Accessories) {
        let oldValue = accessories
        accessories = newValue

        guard hasLoaded, let parent else { return }

        for oldAccessory in oldValue {
            if !newValue.contains(where: { $0.id == oldAccessory.id }) {
                oldAccessory.update(in: parent, reason: .removed)
            }
        }

        for newAccessory in newValue {
            if let oldAccessory = oldValue.first(where: { $0.id == newAccessory.id }) {
                if oldAccessory.hashValue != newAccessory.hashValue {
                    newAccessory.update(in: parent, reason: .modified)
                }
            } else {
                newAccessory.update(in: parent, reason: .added)
            }
        }
    }
}

@MainActor private var associatedObjectKey: UInt8 = 0

extension UIViewController {
    var hostingControllers: [String: Any] {
        get {
            objc_getAssociatedObject(self, &associatedObjectKey) as? [String: Any] ?? [:]
        } set {
            objc_setAssociatedObject(self, &associatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Access or manage a `UIHostingController` instance by its identifier.
    ///
    /// Use this subscript to retrieve, set, or remove `UIHostingController` instances associated with a specific identifier.
    /// This is useful for managing SwiftUI views linked to your `UIViewController` and helps keep track of active hosting controllers.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the `UIHostingController`.
    ///   - contentType: The type of the SwiftUI `View` hosted by the `UIHostingController`. This is used for type-safe access.
    ///
    /// - Returns: A `UIHostingController` instance hosting the specified SwiftUI view type, or `nil` if no controller is associated with the identifier.
    ///
    /// - Tip: The hosting controllers can be managed when navigation accessories are added, modified and removed.
    /// Use the accessory's `id` to keep track of its associated hosting controller.
    /// ```swift
    /// let hostingController = UIHostingController(rootView: MySwiftUIView())
    /// viewController[hostingControllerForID: uniqueID] = hostingController
    ///
    /// if let retrievedController: UIHostingController<MySwiftUIView> = viewController[hostingControllerForID: uniqueID] {
    ///     // Use the retrieved hosting controller
    /// }
    ///
    /// // Remove the hosting controller
    /// viewController[hostingControllerForID: uniqueID, withContentType: MySwiftUIView.self] = nil
    /// ```
    public subscript<Content: View>(
        hostingControllerForID id: String,
        withContentType contentType: Content.Type = Content.self
    ) -> UIHostingController<Content>? {
        get {
            hostingControllers[id] as? UIHostingController<Content>
        } set {
            if let newValue {
                hostingControllers[id] = newValue
            } else {
                hostingControllers.removeValue(forKey: id)
            }
        }
    }
}
