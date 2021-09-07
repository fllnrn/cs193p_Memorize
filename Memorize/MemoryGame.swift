import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: [Card]
    private(set) var name: String
    private(set) var score = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int?

    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let potentialMatch = indexOfOneAndOnlyFaceUpCard {
                if cards[potentialMatch].content == cards[chosenIndex].content {
                    cards[potentialMatch].isMatched = true
                    cards[chosenIndex].isMatched = true
                    score += 2 * scoreBump()
                } else {
                    if cards[potentialMatch].isSeen {
                        score -= 1 * scoreBump()
                    }
                    if cards[chosenIndex].isSeen {
                        score -= 1 * scoreBump()
                    }
                }
                print("score \(score)")
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
            lastCardChooseTime = Date()
        }
    }
    var lastCardChooseTime = Date()
    
    func scoreBump() -> Int {
        let secondsBetween = Int(abs(Date().distance(to: lastCardChooseTime)))
        return max(10 - secondsBetween, 1)
    }
    
    
    struct Card: Identifiable {
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
