//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Андрей Гавриков on 22.06.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    
    @ObservedObject
    var game: EmojiMemoryGame
    
    private func cardShirtStyle(width: CGFloat) -> RadialGradient {
        RadialGradient(gradient: Gradient(colors: [game.themeColor, game.themeColor.opacity(0.2)]),
                       center: .center, startRadius: 20,
                       endRadius: width)
    }
    
    var body: some View {
        VStack {
            Text("\(EmojiMemoryGame.theme.name) : \(game.score)")
            AspectVGrid(items:  game.cards, aspectRatio: 2/3, content: { card in
                
                if card.isMatched && !card.isFaceUp {
                    Rectangle().opacity(0)
                } else {
                CardView(card: card, theme: cardShirtStyle(width: CGFloat(100)))
                    .padding(3)
                    .onTapGesture {
                        game.choose(card)
                    }
                }
                
            })
            .foregroundColor(game.themeColor)
            Spacer()
            Button {
                game.newGame()
                    } label: {
                        VStack{
                            Image(systemName: "gamecontroller.fill").font(.largeTitle)
                            Text("NEW GAME").font(.footnote)
                        }
                    }
        }
        .padding(.horizontal)
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
                            Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
                                .padding(DrawingConstants.piePadding)
                                .opacity(DrawingConstants.pieOpacity)
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
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
        static let piePadding: CGFloat = 5
        static let pieOpacity: CGFloat = 0.5
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game).preferredColorScheme(.dark)
    }
}
