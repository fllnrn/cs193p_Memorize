//
//  ThemeStore.swift
//  Memorize
//
//  Created by Андрей Гавриков on 15.12.2021.
//

import Foundation


struct RGBAColor: Equatable, Codable, Hashable {
    var r, g, b, a: Double
}


struct Theme: Equatable, Identifiable, Codable, Hashable {
    var id: Int
    
    var name: String
    var emojis: [String]
    var numberOfPairs: Int
    var color: RGBAColor
    
    
    init(name: String, emojis: [String], color: RGBAColor, id: Int) {
        self.name = name
        self.emojis = emojis
        numberOfPairs = emojis.count
        self.color = color
        self.id = id
    }
    
    init(name: String, emojis: [String], numberOfPairs: Int, color: RGBAColor, id: Int) {
        self.name = name
        self.emojis = emojis
        self.numberOfPairs = numberOfPairs
        self.color = color
        self.id = id
    }
    
    static let def = Theme(name: "def", emojis: ["🚗","🚌","🏎","🚑"], numberOfPairs: -1, color: RGBAColor(color: .black), id: -1)
    
}

class ThemeStore: ObservableObject {
    @Published var themes = [Theme]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    init() {
        restoreFromUserDefaults()
        if themes.isEmpty {
            addTheme(name: "Mix", emojis: ["🤡","💩","👻","💀","👽","👾","👮🏿‍♀️","👩🏻‍🦰","👀","🫀","👲","🧶","🍀"
                                           ,"😇","🧑‍⚕️","🪂","🏄‍♂️","🛶","🚥","🧡","🇧🇩","🥶","🤯","🪳","🦖"],
                     numberOfPairs: 10, color: RGBAColor(color: .black))
            addTheme(name: "Cars", emojis: ["🚗","🚌","🏎","🚑","🚒","🚛","✈️","🚃"], numberOfPairs: 8, color: RGBAColor(r: 0.5, g: 1, b: 0.5, a: 1))
            addTheme(name: "Balls", emojis: ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉"], numberOfPairs: 8, color: RGBAColor(r: 0.5, g: 0.5, b: 1, a: 1))
            addTheme(name: "Flags", emojis: ["🏳️","🇦🇽","🇧🇬","🇨🇦","🇨🇮","🇱🇻","🇲🇭","🇯🇵","🇯🇪","🇸🇮","🇰🇳","🇺🇿",], numberOfPairs: 10, color: RGBAColor(r: 0.5, g: 0.5, b: 0.3, a: 1))
            addTheme(name: "Animals", emojis: ["🐶","🐱","🐰","🦊","🐻","🐼","🐨","🐵","🐷","🐸","🐤","🐝",], numberOfPairs: -1, color: RGBAColor(r: 0.5, g: 0.7, b: 0.4, a: 1))
        }
    }
    let userDefaultsKey = "themes"
    
    private func storeInUserDefaults() {
        let data = try? JSONEncoder().encode(themes)
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey), let decodedThemes = try? JSONDecoder().decode([Theme].self, from: data) {
            themes = decodedThemes
        }
    }
    // MARK: Intent
    
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    @discardableResult
    func removeTheme(at index: Int) -> Int {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }
    
    @discardableResult
    func addTheme(name: String, emojis: [String], numberOfPairs: Int, color: RGBAColor, at index: Int = 0) -> Int {
        let uniqueId = (themes.max(by: {$0.id < $1.id})?.id ?? 0) + 1
        let theme = Theme(name: name, emojis: emojis, numberOfPairs: numberOfPairs, color: color, id: uniqueId)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
        return safeIndex
    }
}
