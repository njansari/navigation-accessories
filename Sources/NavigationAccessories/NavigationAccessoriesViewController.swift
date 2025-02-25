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
