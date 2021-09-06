import SwiftUI
class EmojiMemoryGame: ObservableObject{
    static let themes = [
        ["🤡","💩","👻","💀","👽","👾","👮🏿‍♀️","👩🏻‍🦰","👀","🫀","👲","🧶","🍀"
         ,"😇","🧑‍⚕️","🪂","🏄‍♂️","🛶","🚥","🧡","🇧🇩","🥶","🤯","🪳","🦖"],
        ["🚗","🚌","🏎","🚑","🚒","🚛","✈️","🚃"],
        ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉"]
    ]
    
    static let emojis = ["🤡","💩","👻","💀","👽","👾","👮🏿‍♀️","👩🏻‍🦰","👀","🫀","👲","🧶","🍀"
                         ,"😇","🧑‍⚕️","🪂","🏄‍♂️","🛶","🚥","🧡","🇧🇩","🥶","🤯","🪳","🦖"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) {id in
            emojis[id]
        }
    }
    
    @Published
    private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    
    // MARK: - Intents
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    
}
