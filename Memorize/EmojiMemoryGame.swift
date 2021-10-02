import SwiftUI
class EmojiMemoryGame: ObservableObject{
    typealias Card = MemoryGame<String>.Card
    
    static let themes = [Theme(name: "Mix", emojis: ["🤡","💩","👻","💀","👽","👾","👮🏿‍♀️","👩🏻‍🦰","👀","🫀","👲","🧶","🍀"
                               ,"😇","🧑‍⚕️","🪂","🏄‍♂️","🛶","🚥","🧡","🇧🇩","🥶","🤯","🪳","🦖"],
                               numberOfPairs: 10, color: "blue"),
                         Theme(name: "Cars", emojis: ["🚗","🚌","🏎","🚑","🚒","🚛","✈️","🚃"], numberOfPairs: 8, color: "red"),
                         Theme(name: "Balls", emojis: ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉"], numberOfPairs: 8, color: "orange"),
                         Theme(name: "Flags", emojis: ["🏳️","🇦🇽","🇧🇬","🇨🇦","🇨🇮","🇱🇻","🇲🇭","🇯🇵","🇯🇪","🇸🇮","🇰🇳","🇺🇿",], numberOfPairs: 10, color: "gray"),
                         Theme(name: "Animals", emojis: ["🐶","🐱","🐰","🦊","🐻","🐼","🐨","🐵","🐷","🐸","🐤","🐝",], numberOfPairs: nil, color: "yellow")]
    

    static func createMemoryGame() -> MemoryGame<String> {
        if let newTheme = themes.randomElement() {
            theme = newTheme
        }
        let emojis = theme.emojis.shuffled()
        let numberOfPairs: Int
        if theme.numberOfPairs != nil  {
            numberOfPairs = min(theme.numberOfPairs!, theme.emojis.count)
        } else {
            numberOfPairs = Int.random(in: 4...emojis.count)
        }
        
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs, themeName: theme.name) {index in emojis[index]}
    }
    
    static var theme: Theme = themes.randomElement()!
    
    @Published
    private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: [Card] {
        return model.cards
    }
    
    var themeColor: Color {
        let colorDict : [String:Color] = ["yellow": .yellow, "gray": .gray, "orange": .orange, "red": .red, "blue": .blue]
        if let color = colorDict[EmojiMemoryGame.theme.color] {
            return color
        }
        return .blue
    }
    
    var score: Int {
        return Int(model.score)
    }
    
    struct Theme {
        var name: String
        var emojis: [String]
        var numberOfPairs: Int?
        var color: String
        init(name: String, emojis: [String], color: String) {
            self.name = name
            self.emojis = emojis
            numberOfPairs = emojis.count
            self.color = color
        }
        init(name: String, emojis: [String], numberOfPairs: Int?, color: String) {
            self.name = name
            self.emojis = emojis
            self.numberOfPairs = numberOfPairs
            self.color = color
        }
    }
    
    // MARK: - Intents
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func newGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }

}

