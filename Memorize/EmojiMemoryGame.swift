import SwiftUI
class EmojiMemoryGame: ObservableObject{
    typealias Card = MemoryGame<String>.Card
    
    init(theme: Theme) {
        self.theme = theme
    }
    

    static func createMemoryGame(numberOfPairs: Int, emojis: [String]) -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs > 0 ? numberOfPairs : emojis.count) {index in emojis[index]}
    }
    
    var theme: Theme {
        didSet {
            if theme != oldValue {
                newGame(with: theme)
            }
        }
    }
    
    @Published
    private var model: MemoryGame<String> = createMemoryGame(numberOfPairs: Theme.def.numberOfPairs, emojis: Theme.def.emojis)
    
    
    var cards: [Card] {
        return model.cards
    }
    
    var score: Int {
        return Int(model.score)
    }

    
    // MARK: - Intents
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func newGame(with newTheme: Theme? = nil) {
        if newTheme != nil {
            theme = newTheme!
        }
        let emojis = theme.emojis.shuffled()
        let numberOfPairs: Int
        if theme.numberOfPairs > 0  {
            numberOfPairs = min(theme.numberOfPairs, theme.emojis.count)
        } else {
            numberOfPairs = Int.random(in: 4...emojis.count)
        }
        model = EmojiMemoryGame.createMemoryGame(numberOfPairs: numberOfPairs, emojis: emojis)
    }
    
}


