import SwiftUI

public extension View {
    func navigationWeeTitle(_ title: String?) -> some View {
        navigationAccessory(WeeTitleAccessory(title: title))
    }

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
