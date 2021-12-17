//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Андрей Гавриков on 15.12.2021.
//

import SwiftUI
    
struct ThemeEditor: View {
    @Binding var theme: Theme
    
    
    var body: some View {
        Form {
            nameSection
            colorSection
            addEmojiSection
            removeEmojiSection
            emojisCountSection
        }
        .navigationTitle(theme.name)
    }
    
    var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $theme.name)
        }
    }
    @State var emojisToAdd = ""
    
    var colorSection: some View {
        Section(header: Text("Color")){
            VStack {
                ColorPicker("Color", selection: $theme.uiColor)
            }
        }
    }
    
    var addEmojiSection: some View {
        Section(header: Text("Add emojis")){
            VStack {
                TextField("", text: $emojisToAdd)
                    .onChange(of: emojisToAdd) { newValue in
                        addEmojis(newValue)
                    }
                
            }
        }
    }
    
    var removeEmojiSection: some View {
        Section {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 20))]) {
                ForEach (theme.emojis.indices, id: \.self) { index in
                    Text(theme.emojis[index])
                        .onTapGesture {
                            withAnimation {
                                _ = theme.emojis.remove(at: index)
                            }
                        }
                }
                
            }
        } header: {
            Text("Remove emojis")
        }
    }
    @State var numberOfPairEdit = -1
    
    var emojisCountSection: some View {
        Section {
            Stepper("Number of Pairs = \(theme.numberOfPairs)", value: $theme.numberOfPairs)
        } header: {
            Text("Emojis count")
        }

        
    }
    
    
    private func addEmojis(_ emoji: String) {
        theme.emojis = ([emoji] + theme.emojis)
    }
    
    
    
    
    
}

struct ThemeEditor_Previews: PreviewProvider {
    
    static var previews: some View {
        let theme = Theme.def
        ThemeEditor(theme: .constant(theme))
    }
}
