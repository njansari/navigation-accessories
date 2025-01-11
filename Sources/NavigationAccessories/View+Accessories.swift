import SwiftUI

struct NavigationAccessoriesKey: PreferenceKey {
    nonisolated(unsafe) static let defaultValue: Accessories = []

    static func reduce(value: inout Accessories, nextValue: () -> Accessories) {
        value = nextValue()
    }
}

public extension View {
    func navigationAccessoriesTarget(isEnabled: Bool = true) -> some View {
        backgroundPreferenceValue(NavigationAccessoriesKey.self) { accessories in
            if isEnabled {
                NavigationAccessoriesView(accessories: accessories)
            }
        }
    }

    func navigationAccessory(_ accessory: (any NavigationAccessory)?) -> some View {
        transformPreference(NavigationAccessoriesKey.self) { accessories in
            if let accessory {
                accessories.insert(accessory)
            }
        }
    }
}
