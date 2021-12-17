import SwiftUI
class EmojiMemoryGame: ObservableObject{
    typealias Card = MemoryGame<String>.Card
    
    static let themes: [Theme] = [Theme(name: "Mix", emojis: ["🤡","💩","👻","💀","👽","👾","👮🏿‍♀️","👩🏻‍🦰","👀","🫀","👲","🧶","🍀"
                               ,"😇","🧑‍⚕️","🪂","🏄‍♂️","🛶","🚥","🧡","🇧🇩","🥶","🤯","🪳","🦖"],
                               numberOfPairs: 10, color: RGBAColor(color: .blue), id: 0),
                         Theme(name: "Cars", emojis: ["🚗","🚌","🏎","🚑","🚒","🚛","✈️","🚃"], numberOfPairs: 8, color: RGBAColor(color: .blue), id: 1),
                         Theme(name: "Balls", emojis: ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉"], numberOfPairs: 8, color: RGBAColor(color: .blue), id: 2),
                         Theme(name: "Flags", emojis: ["🏳️","🇦🇽","🇧🇬","🇨🇦","🇨🇮","🇱🇻","🇲🇭","🇯🇵","🇯🇪","🇸🇮","🇰🇳","🇺🇿",], numberOfPairs: 10, color: RGBAColor(color: .blue), id: 3),
                         Theme(name: "Animals", emojis: ["🐶","🐱","🐰","🦊","🐻","🐼","🐨","🐵","🐷","🐸","🐤","🐝",], numberOfPairs: -1, color: RGBAColor(color: .blue), id: 4)]
    

    static func createMemoryGame(numberOfPairs: Int, emojis: [String]) -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) {index in emojis[index]}
    }
    
    var theme: Theme = themes.randomElement()! {
        didSet {
            if theme != oldValue {
                newGame(with: theme)
            }
        }
    }
    
    @Published
    private var model: MemoryGame<String> = createMemoryGame(numberOfPairs: EmojiMemoryGame.themes.first?.numberOfPairs ?? 5, emojis: EmojiMemoryGame.themes.first?.emojis ?? ["🚗","🚌","🏎","🚑","🚒"])
    
    
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


