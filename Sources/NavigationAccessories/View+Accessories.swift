import SwiftUI

struct NavigationAccessoriesKey: PreferenceKey {
    nonisolated(unsafe) static let defaultValue: Accessories = []

    static func reduce(value: inout Accessories, nextValue: () -> Accessories) {
        value = nextValue()
    }
}

public extension View {
    /// Marks a view as a target for navigation accessories.
    ///
    /// Use this modifier to designate a view where `NavigationAccessory` instances can be applied.
    /// This is normally on the outer level at the end of the content in a `NavigationStack` or `NavigationSplitView` column.
    ///
    /// - Parameter isEnabled: A Boolean value indicating whether navigation accessories are enabled for this view. The default is `true`.
    func navigationAccessoriesTarget(isEnabled: Bool = true) -> some View {
        backgroundPreferenceValue(NavigationAccessoriesKey.self) { accessories in
            NavigationAccessoriesView(accessories: isEnabled ? accessories : [])
        }
    }
    
    /// Adds a navigation accessory to the view.
    ///
    /// Use this modifier to associate a `NavigationAccessory` with the view.
    /// The accessory will be applied to the nearest target designated by `navigationAccessoriesTarget(isEnabled:)`.
    ///
    /// - Parameter accessory: An optional `NavigationAccessory` instance to be applied.
    /// If `nil`, no accessory is added and any exisiting instance of this accessory is removed.
    func navigationAccessory(_ accessory: (any NavigationAccessory)?) -> some View {
        transformPreference(NavigationAccessoriesKey.self) { accessories in
            if let accessory {
                accessories.insert(accessory)
            }
        }
    }
}
