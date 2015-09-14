//: Anschauen! https://developer.apple.com/videos/wwdc/2015/?id=408

import Foundation

//: Static Type safty Hole

func binarySearchClass(sortedKeys: [OrderedClass], forKey k: OrderedClass) -> Int {
    var lo = 0
    var hi : Int = sortedKeys.count
    while hi > lo {
        let mid = lo + (hi - lo) / 2
        if sortedKeys[mid].precedes(k) {
            lo = mid + 1
        }
        else { hi = mid }
    }
    return lo
}

class OrderedClass {
    func precedes(other: OrderedClass) -> Bool
    {
        fatalError("implement me!")
    }
}

class NumberClass : OrderedClass {
    var value: Double = 0
    override func precedes(other: OrderedClass) -> Bool {
        return value < (other as! NumberClass).value
    }
}

//: Start With a Protocol

protocol Ordered {
    func precedes(other: Self) -> Bool
}

struct Number : Ordered {
    var value: Double = 0
    func precedes(other: Number) -> Bool {
        return value < other.value
    }
}

func binarySearch<T : Ordered>(sortedKeys: [T], forKey k: T) -> Int {
    var lo = 0
    var hi : Int = sortedKeys.count
    while hi > lo {
        let mid = lo + (hi - lo) / 2
        if sortedKeys[mid].precedes(k) {
            lo = mid + 1
        }
        else { hi = mid }
    }
    return lo
}
