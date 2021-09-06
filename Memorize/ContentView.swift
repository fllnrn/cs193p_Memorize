//
//  ContentView.swift
//  Memorize
//
//  Created by Андрей Гавриков on 22.06.2021.
//

import SwiftUI

struct ContentView: View {
    var themes = [
        ["🤡","💩","👻","💀","👽","👾","👮🏿‍♀️","👩🏻‍🦰","👀","🫀","👲","🧶","🍀"],
        ["🚗","🚌","🏎","🚑","🚒","🚛","✈️","🚃"],
        ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉"]
    ]
    
    
    @State var emojis = ["🤡","💩","👻","💀","👽","👾","👮🏿‍♀️","👩🏻‍🦰","👀","🫀","👲","🧶","🍀"]
    @State var emojisCount = 10

    init() {
        emojis = themes[0]
        emojisCount = emojis.count
    }
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(emojis[0..<emojisCount], id: \.self) { emoji in
                        CardView(content: emoji)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            .foregroundColor(.red)
            Spacer()
            HStack {
                Spacer()
                theme1
                Spacer()
                theme2
                Spacer()
                theme3
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    var theme1: some View {
        Button {
            emojis = themes[0].shuffled()
            emojisCount = emojis.count
        } label: {
            VStack {
                Image(systemName: "face.smiling").font(.largeTitle)
                Text("faces")
                    .font(.footnote)
            }
        }
    }
    
    var theme2: some View {
        Button {
            emojis = themes[1].shuffled()
            emojisCount = emojis.count
        } label: {
            VStack {
                Image(systemName: "car").font(.largeTitle)
                Text("cars")
                    .font(.footnote)
            }
        }
    }
    
    var theme3: some View {
        Button {
            emojis = themes[2].shuffled()
            emojisCount = emojis.count
        } label: {
            VStack {
                Image(systemName: "airplane").font(.largeTitle)
                Text("planes")
                    .font(.footnote)
            }
        }
    }
    
}

struct CardView: View {
    var content: String
    @State var isFaceUp: Bool = true
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
//        ContentView().preferredColorScheme(.light)
    }
}
