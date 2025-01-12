import SwiftUI

public extension View {
    /// Sets a custom "wee" title for the navigation bar.
    ///
    /// Use this modifier to display a small, custom title above the standard large navigation bar title.
    ///
    /// - Parameter title: A string representing the title to display. If `nil`, no custom title is set.
    func navigationWeeTitle(_ title: String?) -> some View {
        navigationAccessory(WeeTitleAccessory(title: title))
    }
    
    /// Adds a custom accessory view aligned with the large title in the navigation bar.
    ///
    /// Use this modifier to provide a SwiftUI view that is displayed alongside the large title in the navigation bar.
    ///
    /// - Parameters:
    ///   - alignsToBaseline: A Boolean value indicating whether the accessory should align with the large title's baseline. The default is `true`.
    ///   - content: A closure returning the view to display as the accessory.
    func navigationLargeTitleAccessoryView<Content: View>(
        alignsToBaseline: Bool = true,
        content: () -> Content
    ) -> some View {
        navigationAccessory(
            LargeTitleAccessoryViewAccessory(
                alignsToBaseline: alignsToBaseline,
                content: HashableView(content: content())
            )
        )
    }
    
    /// Adds a custom bottom palette to the navigation bar.
    ///
    /// Use this modifier to provide a SwiftUI view that is pinned below the title as part of the navigation bar.
    ///
    /// - Parameters:
    ///   - displaysWhenSearchActive: A Boolean value indicating whether the palette should be visible when a search is active. The default is `false`.
    ///   - height: An optional height for the palette. If `nil`, the view's default height is used.
    ///   - content: A closure returning the view to display in the palette.
    func navigationBottomPalette<Content: View>(
        displaysWhenSearchActive: Bool = false,
        height: CGFloat? = nil,
        content: () -> Content
    ) -> some View {
        navigationAccessory(
            BottomPaletteAccessory(
                displaysWhenSearchActive: displaysWhenSearchActive,
                height: height,
                content: HashableView(content: content())
            )
        )
    }
    
    /// Places a custom SwiftUI view in the center of the navigation bar, supporting dynamic height adjustments.
    ///
    /// Unlike the standard `titleView` property in UIKit, this modifier allows the navigation bar's height to adjust
    /// to accommodate the custom view, enabling taller layouts.
    ///
    /// - Parameters:
    ///   - height: An optional height for the custom title view. If `nil`, the view's default height is used.
    ///   - hidesStandardTitle: A Boolean value indicating whether the standard title should be hidden. The default is `false`.
    ///   - content: A closure returning the view to display as the custom title.
    func navigationTitleView<Content: View>(
        height: CGFloat? = nil,
        hidesStandardTitle: Bool = false,
        content: () -> Content
    ) -> some View {
        navigationAccessory(
            TitleViewAccessory(
                height: height,
                hideStandardTitle: hidesStandardTitle,
                content: HashableView(content: content())
            )
        )
    }
}
