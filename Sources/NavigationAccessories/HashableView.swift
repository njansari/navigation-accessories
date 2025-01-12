import SwiftUI

/// A wrapper for SwiftUI views that conforms to `Hashable`.
///
/// Use `HashableView` to wrap a SwiftUI `View` when `Hashable` conformance is required, such as when working with protocols or APIs that require hashable elements.
public struct HashableView<Content: View>: Hashable, View {
    let id: UUID
    let content: Content
    
    /// Creates a new hashable wrapper for a SwiftUI view.
    /// - Parameter content: The SwiftUI view to wrap.
    public init(content: Content) {
        self.id = UUID()
        self.content = content
    }

    public var body: some View {
        content
    }

    nonisolated public static func == (lhs: HashableView<Content>, rhs: HashableView<Content>) -> Bool {
        lhs.id == rhs.id
    }

    nonisolated public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
