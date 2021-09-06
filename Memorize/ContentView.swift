//
//  ContentView.swift
//  Memorize
//
//  Created by Андрей Гавриков on 22.06.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject
    var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: widthThatBestFits(cardCount: viewModel.cards.count)))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
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
//            emojis = themes[index].shuffled()
//            emojisCount = Int.random(in: 4...emojis.count)
            
        } label: {
            VStack{
                Image(systemName: imgName).font(.largeTitle)
                Text(captionText).font(.footnote)
            }
        }
    }
    
    
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill()
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game).preferredColorScheme(.dark)
//        ContentView().preferredColorScheme(.light)
    }
}
