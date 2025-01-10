import SwiftUI

public struct HashableView<Content: View>: Hashable, View {
    let id: UUID
    let content: Content

    init(content: Content) {
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
