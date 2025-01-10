struct Accessories: ExpressibleByArrayLiteral, Sequence {
    typealias Accessory = any NavigationAccessory

    private var accessories: [Accessory] = []

    init(arrayLiteral elements: Accessory...) {
        accessories = elements
    }

    mutating func insert(_ accessory: Accessory) {
        if !accessories.contains(where: { $0.id == accessory.id }) {
            accessories.append(accessory)
        }
    }

    func makeIterator() -> [Accessory].Iterator {
        accessories.makeIterator()
    }
}
