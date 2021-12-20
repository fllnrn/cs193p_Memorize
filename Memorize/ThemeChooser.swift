//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Андрей Гавриков on 15.12.2021.
//

import SwiftUI

struct ThemeChooser: View {
    @EnvironmentObject var store: ThemeStore
    
    @State private var editMode: EditMode = .inactive
    @State private var themeToEdit: Theme? = nil
    @State private var games = [Int: EmojiMemoryGameView]()
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach (store.themes) { theme in
                    NavigationLink(destination: gameView(for: theme)) {
                        VStack(alignment: .leading) {
                            Text(theme.name)
                                .font(.headline)
                                .foregroundColor(Color(rgbaColor: theme.color))
                            let count = theme.numberOfPairs < 1 ? "All" : String(theme.numberOfPairs)
                            let emojis = theme.emojis.reduce("", {$0 + $1})
                            Text("\(count) of \(String(emojis))")
                                .font(.footnote)
                        }
                        .gesture(editMode == .active ? tap(on: theme) : nil)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        games.removeValue(forKey: store.themes[index].id)
                    }
                    store.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffsets in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffsets)
                }
            }
            .navigationTitle("Memorize")
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            let newIndex = store.addTheme(name: "New", emojis: [], numberOfPairs: -1, color: RGBAColor(r: 1, g: 1, b: 1, a: 1))
                            themeToEdit = store.themes[newIndex]
                        } label: {
                            Image(systemName: "plus")
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
        .sheet(item: $themeToEdit) { themeToEdit in
            ThemeEditor(theme: $store.themes[themeToEdit])
        }
    }
    private func tap(on theme: Theme) -> some Gesture {
        TapGesture().onEnded {
            print("Tap on \(theme.name)")
            themeToEdit = theme
        }
    }
    private func gameView(for theme: Theme) -> some View {
        if let savedView = games[theme.id] {
            return savedView
        } else {
            let newGameView = EmojiMemoryGameView(game: EmojiMemoryGame(theme: theme))
            games[theme.id] = newGameView
            return newGameView
        }
    }
    
}


extension Theme {
    var uiColor: Color {
        get {
            return Color(rgbaColor: color)
        }
        set {
            color = RGBAColor(color: newValue)
        }
    }
}

extension Color {
    init(rgbaColor: RGBAColor) {
        self.init(.sRGB, red: rgbaColor.r, green: rgbaColor.g, blue: rgbaColor.b, opacity: rgbaColor.a)
    }
}

extension RGBAColor {
    
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 1
        if let cgColor = color.cgColor {
            UIColor(cgColor: cgColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        }
        self.init(r: Double(red), g: Double(green), b: Double(blue), a: Double(alpha))
    }
}


struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser().environmentObject(ThemeStore())
    }
}


