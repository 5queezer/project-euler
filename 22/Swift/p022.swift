import Foundation

if CommandLine.argc == 2 {
    let file = try FileReader(CommandLine.arguments[1])
    try file.parse()
}

enum MyError: Error {
    case cardError(String)
    case fileError(String)
    case bothHandsAreEqual
}

class FileReader {
    let text: String
    
    init(_ file: String) throws {
        guard let dir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
            throw MyError.fileError("Could not find Downloads")
        }
        let fileURL = dir.appendingPathComponent(file)
        
        do {
            self.text = try String(contentsOf: fileURL, encoding: .utf8)
        }
        catch {
            throw MyError.fileError("Could not read \(fileURL)")
        }
    }
    
    func parse() throws {
        let lines = text.split(separator: "\n")
        var player1 = 0
        for line in lines {
            if line.isEmpty {
                continue
            }
            let cards = line.split(separator: " ")
            let hand1 = try Hand(Set(cards[0...4].map{
                try Card(String($0))
            }))
            let hand2 = try Hand(Set(cards[5...9].map{
                try Card(String($0))
            }))
            if hand1 > hand2 {
                player1 += 1
            }
        }
        print("\(player1)")
    }
}

public enum Value: UInt8, Equatable, Comparable {
    public static func < (lhs: Value, rhs: Value) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    public static func - (lhs: Value, rhs: Value) -> UInt8 {
        return lhs.rawValue - rhs.rawValue
    }
    
    case none = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
    public init(_ value: Character) {
        switch value {
        case "2"..."9":
            let intValue = value.unicodeScalars.first!.value - Unicode.Scalar("0").value
            self.init(rawValue: UInt8(intValue))!
        case "T":
            self = .ten
        case "J":
            self = .jack
        case "Q":
            self = .queen
        case "K":
            self = .king
        case "A":
            self = .ace
        default:
            self = .none
        }
    }
    public init(_ value: Value) {
        self = value
    }
}
public enum Suit: Character {
    case none = "\0", club = "C", diamond = "D", heart = "H", spade = "S"
}
public struct Card: Equatable, Hashable, Comparable {
    public static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.value == rhs.value && lhs.suit == rhs.suit
    }
    
    public static func < (lhs: Card, rhs: Card) -> Bool {
        return lhs.value.rawValue < rhs.value.rawValue
    }
    
    let value: Value
    let suit: Suit
    public init(_ card: String) throws {
        guard card.count == 2 else {
            throw MyError.cardError("Invalid Card \(card)")
        }
        
        let index0 = card.index(card.startIndex, offsetBy: 0)
        let index1 = card.index(card.startIndex, offsetBy: 1)
        self.init(value: Value(card[index0]), suit: Suit(rawValue: card[index1])!)
    }
    init(value: Value, suit: Suit) {
        self.value = value
        self.suit = suit
    }
}

public func valuePairs(_ hand: Set<Card>) -> [Value: Int] {
    let mappedItems = hand.map { ($0.value, 1) }
    let counts = Dictionary(mappedItems, uniquingKeysWith: +)
    return counts
}

public enum Hand: Equatable, Comparable {
    
    public typealias RawValue = Int

    public static func < (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.rank.0 < rhs.rank.0 {
            return true
        } else if ( lhs.rank.0 > rhs.rank.0 ) {
            return false
        }
        for (value1, value2) in zip(lhs.rank.1, rhs.rank.1) {
            if value1 < value2 {
                return true
            } else if value1 > value2 {
                return false
            }
        }
        assert (false)
    }
    
    case highcard([Value]),
         onepair(Value, [Value]),
         twopairs(Value, Value, Value),
         threeofakind(Value, [Value]),
         straight(Value),
         flush([Value]),
         fullhouse(Value, Value),
         fourofakind(Value, Value),
         straightflush(Value),
         royalflush
    
    public init(_ cards: String) {
        let cardsArray = cards.split(separator: " ")
        self.init(Set(cardsArray.map({
            try! Card(String($0))
        })))
    }
    
    public init(_ cards: Set<Card>) {
        assert(cards.count == 5)
        let flush = cards.allSatisfy({ $0.suit == Array(cards).first!.suit })
        let maxV = cards.max()!.value
        let minV = cards.min()!.value
        let valuePairs = valuePairs(cards)
        let pairs = valuePairs.values.sorted(by: {$1 < $0})
        let straight = maxV - minV == 4 && pairs.allSatisfy({$0 == 1})
        
        // Royal Flush
        if flush && straight && maxV == .ace {
            self = .royalflush
        }
        
        // Straight Flush
        else if flush && straight {
            self = .straightflush(maxV)
        }
        
        // Four of a kind
        else if pairs.contains(4) {
            self = .fourofakind(
                Value(valuePairs.first(where: {$0.value == 4})!.key),
                Value(valuePairs.first(where: {$0.value == 1})!.key)
            )
        }

        // Full House
        else if pairs.contains(3) && pairs.contains(2) {
            let threePairs = valuePairs.first(where: {$0.value == 3})!.key
            let twoPairs = valuePairs.first(where: {$0.value == 2})!.key
            self = .fullhouse(threePairs, twoPairs)
        }

        // Flush
        else if flush {
            self = .flush(valuePairs.keys.sorted(by: {$1 < $0}))
        }

        // Straight
        else if straight {
            self = .straight(maxV)
        }

        // Three of a kind
        else if pairs.contains(3) {
            self = .threeofakind(
                valuePairs.first(where: {_, value in value == 3})!.key,
                valuePairs.filter({_, value in value == 1}).keys.sorted(by: {$1 < $0})
            )
        }

        // Two pairs
        else if pairs.filter({$0 == 2}).count == 2 {
            let p = valuePairs.filter({key, value in value == 2}).sorted(by: {$1.key < $0.key})
            self = .twopairs(
                p.first!.key,
                p.last!.key,
                valuePairs.first(where: {key, value in value == 1})!.key
            )
        }

        // One pair
        else if pairs.contains(2) {
            self = .onepair(
                valuePairs.first(where: {$0.value == 2})!.key,
                valuePairs.filter({$0.value == 1}).sorted(by: {$1.key < $0.key}).map(\.key)
            )
        }

        // High Card
        else {
            self = .highcard(valuePairs.keys.sorted{$1 < $0})
        }

    }
    
    public var rank: (Int, [UInt8]) {
        switch self {
        case .highcard(let array):
            return (1, array.map(\.rawValue))
        case .onepair(let value, let array):
            return (2, [value.rawValue] + array.map(\.rawValue))
        case .twopairs(let value1, let value2, let value3):
            return (3, [value1.rawValue, value2.rawValue, value3.rawValue])
        case .threeofakind(let value, let array):
            return (4, [value.rawValue] + array.map(\.rawValue))
        case .straight(let value):
            return (5, [value.rawValue])
        case .flush(let array):
            return (6, array.map(\.rawValue))
        case .fullhouse(let value1, let value2):
            return (7, [value1.rawValue, value2.rawValue])
        case .fourofakind(let value1, let value2):
            return (8, [value1.rawValue, value2.rawValue])
        case .straightflush(let value):
            return (9, [value.rawValue])
        case .royalflush:
            return (10, [Value.ace.rawValue])
        }
    }
}
