//
//  ContentView.swift
//  Memorize
//
//  Created by Андрей Гавриков on 22.06.2021.
//

import SwiftUI

struct ContentView: View {
    var themes = [
        ["🤡","💩","👻","💀","👽","👾","👮🏿‍♀️","👩🏻‍🦰","👀","🫀","👲","🧶","🍀"
         ,"😇","🧑‍⚕️","🪂","🏄‍♂️","🛶","🚥","🧡","🇧🇩","🥶","🤯","🪳","🦖"],
        ["🚗","🚌","🏎","🚑","🚒","🚛","✈️","🚃"],
        ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉"]
    ]
    
    
    @State var emojis = ["🤡","💩","👻","💀","👽","👾","👮🏿‍♀️","👩🏻‍🦰","👀","🫀","👲","🧶","🍀"
                         ,"😇","🧑‍⚕️","🪂","🏄‍♂️","🛶","🚥","🧡","🇧🇩","🥶","🤯","🪳","🦖"]
    @State var emojisCount = 10 // 10-60 0.16 25-50 0,5  4-100 0,04

    init() {
        emojis = themes[0]
        emojisCount = emojis.count
    }
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: widthThatBestFits(cardCount: emojisCount)))]) {
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
                themeChange(0)
                Spacer()
                themeChange(1)
                Spacer()
                themeChange(2)
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    func widthThatBestFits(cardCount: Int) -> CGFloat {
        return CGFloat(400 / cardCount)
    }
    
    func themeChange(_ index: Int) -> some View {
        let imgName, captionText: String
        switch index {
        case 1:
            imgName = "car"
            captionText = "cars"
        case 2:
            imgName = "airplane"
            captionText = "planes"
        default:
            imgName = "face.smiling"
            captionText = "faces"
        }
        return Button {
            emojis = themes[index].shuffled()
            emojisCount = Int.random(in: 4...emojis.count)
            
        } label: {
            VStack{
                Image(systemName: imgName).font(.largeTitle)
                Text(captionText).font(.footnote)
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
