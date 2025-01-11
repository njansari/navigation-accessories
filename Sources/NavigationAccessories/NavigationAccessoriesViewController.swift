import SwiftUI

class NavigationAccessoriesViewController: UIViewController {
    private var accessories: Accessories = []
    private var hasLoaded = false

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        guard !hasLoaded else { return }

        for accessory in accessories {
            accessory.update(in: self, reason: .added)
        }

        hasLoaded = true
    }

    func updateAccessories(with newValue: Accessories) {
        let oldValue = accessories
        accessories = newValue

        guard hasLoaded else { return }

        for oldAccessory in oldValue {
            if !newValue.contains(where: { $0.id == oldAccessory.id }) {
                oldAccessory.update(in: self, reason: .removed)
            }
        }

        for newAccessory in newValue {
            if let oldAccessory = oldValue.first(where: { $0.id == newAccessory.id }) {
                if oldAccessory.hashValue != newAccessory.hashValue {
                    newAccessory.update(in: self, reason: .modified)
                }
            } else {
                newAccessory.update(in: self, reason: .added)
            }
        }
    }
}

@MainActor private var associatedObjectHandle: UInt8 = 0

extension UIViewController {
    var hostingControllers: [String: Any] {
        get {
            objc_getAssociatedObject(self, &associatedObjectHandle) as? [String: Any] ?? [:]
        } set {
            objc_setAssociatedObject(self, &associatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public subscript<Content: View>(
        hostingControllerForID id: String,
        withContentType _: Content.Type = Content.self
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
