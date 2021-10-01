import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: [Card]
    private(set) var name: String
    private(set) var score = 0
    private var prescore = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly }
        set { cards.indices.forEach {cards[$0].isFaceUp = ($0 == newValue)} }
    }

    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0 == card}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatch = indexOfOneAndOnlyFaceUpCard {
                if cards[chosenIndex].isSeen {
                    prescore += scoreBump()
                }
                if cards[potentialMatch].content == cards[chosenIndex].content {
                    cards[potentialMatch].isMatched = true
                    cards[chosenIndex].isMatched = true
                    score += prescore
                } else {
                    score -= prescore
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = chosenIndex
                if cards[chosenIndex].isSeen {
                    prescore = scoreBump()
                }
            }
            lastCardChooseTime = Date()
            print("score \(score) prescore \(prescore)")
        }
    }
    var lastCardChooseTime = Date()
    
    func scoreBump() -> Int {
        let secondsBetween = Int(abs(Date().distance(to: lastCardChooseTime)))
        return max(10 - secondsBetween, 1)
    }
    
    
    struct Card: Identifiable, Equatable {
        var id: Int
        var isFaceUp = false {willSet {if isFaceUp && !newValue {isSeen = true }}}
        var isMatched = false
        var isSeen = false
        var content: CardContent
    }
    
    init(numberOfPairsOfCards: Int, themeName: String, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(id: pairIndex*2, content: content))
            cards.append(Card(id: pairIndex*2+1, content: content))
        }
        cards.shuffle()
        name = themeName
    }
}
extension Array {
    var oneAndOnly: Element? {
        if self.count == 1 {
            return first
        } else {
            return nil
        }
    }
}
