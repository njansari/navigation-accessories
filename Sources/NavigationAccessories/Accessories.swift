struct Accessories: ExpressibleByArrayLiteral, Sequence {
    typealias Accessory = any NavigationAccessory

    private var accessories: [Accessory] = []

    init(arrayLiteral elements: Accessory...) {
        accessories = elements
    }

    mutating func insert(_ accessory: Accessory) {
        if let index = accessories.firstIndex(where: { $0.id == accessory.id }) {
            accessories[index] = accessory
        } else {
            accessories.append(accessory)
        }
    }

    func makeIterator() -> [Accessory].Iterator {
        accessories.makeIterator()
    }
}
