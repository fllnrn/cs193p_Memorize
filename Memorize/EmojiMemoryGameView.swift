//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Андрей Гавриков on 22.06.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    var game: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text("\(game.theme.name) : \(game.score)")
                gameBody
                Spacer()
                HStack {
                    newgame
                    Spacer()
                }
                .padding(.horizontal)
            }
            deckBody
        }
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay )
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var newgame: some View {
        Button {
            withAnimation {
                dealt = []
                game.newGame()
            }
        } label: {
            VStack {
                Image(systemName: "gamecontroller.fill").font(.largeTitle)
                Text("NEW GAME").font(.footnote)
            }
        }
    }
    
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card, themeColor: Color(rgbaColor: game.theme.color))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .scale, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(Color(rgbaColor: game.theme.color))
        .onTapGesture {
                dealtAllCards()
        }
    }

    var gameBody: some View {
        AspectVGrid(items:  game.cards, aspectRatio: CardConstants.aspectRatio, content: { card in
            
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card, themeColor: Color(rgbaColor: game.theme.color))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(3)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            game.choose(card)
                        }
                    }
                }
        })
        .foregroundColor(Color(rgbaColor: game.theme.color))
    }
    
    private func dealtAllCards() {
        for card in game.cards {
            withAnimation(dealAnimation(for: card)) {
                deal(card)
            }
        }
    }
    
    private struct CardConstants {
        static let dealDuration: CGFloat = 1
        static let totalDealDuration: CGFloat = 2
        static let aspectRatio: CGFloat = 2/3
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }

}

struct CardView: View {
    let card: MemoryGame<String>.Card
    let themeColor: Color
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                    .padding(DrawingConstants.piePadding)
                    .opacity(DrawingConstants.pieOpacity)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360: 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp, theme: cardShirtStyle(size: geometry.size))
        }
    }
    
    private func cardShirtStyle(size: CGSize) -> RadialGradient {
        let width = min(size.width, size.height)
        return RadialGradient(gradient: Gradient(colors: [themeColor, .white]),
                       center: .center, startRadius: 0,
                       endRadius: width)
    }
    
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) /  (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
        
    private struct DrawingConstants {
        static let fontSize: CGFloat = 32
        static let fontScale: CGFloat = 0.7
        static let piePadding: CGFloat = 5
        static let pieOpacity: CGFloat = 0.5
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
//        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game).preferredColorScheme(.light)
    }
}


