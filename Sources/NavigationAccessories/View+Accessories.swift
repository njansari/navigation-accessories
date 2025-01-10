import SwiftUI

struct NavigationAccessoriesKey: PreferenceKey {
    nonisolated(unsafe) static let defaultValue: Accessories = []

    static func reduce(value: inout Accessories, nextValue: () -> Accessories) {
        value = nextValue()
    }
}

public extension View {
    func navigationAccessoriesTarget() -> some View {
        backgroundPreferenceValue(NavigationAccessoriesKey.self, NavigationAccessoriesView.init)
    }

    func navigationAccessory(_ accessory: (any NavigationAccessory)?) -> some View {
        transformPreference(NavigationAccessoriesKey.self) { accessories in
            if let accessory {
                accessories.insert(accessory)
            }
        }
    }

    func navigationWeeTitle(_ title: String?) -> some View {
        navigationAccessory(WeeTitleAccessory(title: title))
    }

    func navigationLargeTitleAccessoryView<Content: View>(
        alignsToBaseline: Bool = false,
        content: () -> Content
    ) -> some View {
        navigationAccessory(
            LargeTitleAccessory(
                alignsToBaseline: alignsToBaseline,
                content: HashableView(content: content())
            )
        )
    }

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
