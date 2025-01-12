import UIKit

/// Reasons for updating a `NavigationAccessory`.
///
/// This enum is used to communicate the reason for a change in the state of a `NavigationAccessory` when it is updated in a `UIViewController` context.
public enum NavigationAccessoryUpdateReason {
    /// The accessory has been added to the view controller.
    case added

    /// The accessory has been modified in the view controller.
    case modified

    /// The accessory has been removed from the view controller.
    case removed
}

/// A protocol for defining navigation accessories that interact with a `UIViewController`.
///
/// Conforming types represent custom behaviours or UI components that are applied to the navigation-related features of a `UIViewController`.
/// These accessories can be updated dynamically based on specific reasons.
///
/// - Note: Conformance to `Hashable` and `Identifiable` is required to keep track of accessories.
/// If your custom accessory contains a SwiftUI view as a property, wrap it in a `HashableView` upon initialization.
public protocol NavigationAccessory: Hashable, Identifiable {
    /// A unique identifier for the accessory.
    var id: String { get }
    
    /// Updates the navigation accessory in the provided `UIViewController` context.
    ///
    /// This method is called when the state of the accessory changes.
    /// Implement this method to modify the `UIViewController` (e.g., its navigation bar) based on the specified update reason.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` instance in which the accessory is being updated.
    ///   - reason: The reason for the update, indicating whether the accessory was added, modified, or removed.
    @MainActor func update(in viewController: UIViewController, reason: NavigationAccessoryUpdateReason)
}
