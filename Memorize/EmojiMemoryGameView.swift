//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Андрей Гавриков on 22.06.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject
    var viewModel: EmojiMemoryGame
    
    var cardShirtStyle: RadialGradient {
        RadialGradient(gradient: Gradient(colors: [viewModel.themeColor, viewModel.themeColor.opacity(0.2)]),
                       center: .center, startRadius: 20,
                       endRadius: widthThatBestFits(cardCount: viewModel.cards.count))
    }
    
    var body: some View {
        VStack {
            Text("\(EmojiMemoryGame.theme.name) : \(viewModel.score)").font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: widthThatBestFits(cardCount: viewModel.cards.count)))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card, theme: cardShirtStyle)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(viewModel.themeColor)
            Spacer()
            Button {
                viewModel.newGame()
                    } label: {
                        VStack{
                            Image(systemName: "gamecontroller.fill").font(.largeTitle)
                            Text("NEW GAME").font(.footnote)
                        }
                    }
        }
        .padding(.horizontal)
    }
    func widthThatBestFits(cardCount: Int) -> CGFloat {
        return CGFloat(60)
    }
    
    
    
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    let theme: RadialGradient
    
    var body: some View {
        GeometryReader { geometry in
                    ZStack {
                        let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                        if card.isFaceUp {
                            shape.fill().foregroundColor(.white)
                            shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                            Text(card.content).font(font(in: geometry.size))
                        } else if card.isMatched {
                            shape.opacity(0)
                        } else {
                            shape.fill(theme)
                        }
                    }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
        
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.8
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(viewModel: game).preferredColorScheme(.dark)
    }
}
