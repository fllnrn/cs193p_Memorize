//
//  ContentView.swift
//  Memorize
//
//  Created by Андрей Гавриков on 22.06.2021.
//

import SwiftUI

struct ContentView: View {
    var emojis = ["🤡","💩","👻","💀","👽","👾","👮🏿‍♀️","👩🏻‍🦰","👀","🫀","👲","🧶","🍀"]
    @State var emojisCount = 10
    
    var body: some View {
        VStack {
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
                remove
                Spacer()
                add
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    var add: some View {
        Button {
            if emojisCount < emojis.count {
                emojisCount += 1
            }
        } label: {
            Image(systemName: "plus.circle")
        }
    }
    
    var remove: some View {
        Button {
            if emojisCount > 1 {
                emojisCount -= 1
            }
        } label: {
            Image(systemName: "minus.circle")
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
