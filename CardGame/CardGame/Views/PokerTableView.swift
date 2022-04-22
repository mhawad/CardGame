//
//  PokerTableView.swift
//  CardGame
//
//  Created by Patrick Fuller on 4/22/22.
//

import SwiftUI

struct PokerTableView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .background(.blue)
                .foregroundColor(.black.opacity(0.7))
                .ignoresSafeArea()
            HStack {
                CardView(card: Card(11, of: .heart))
                CardView(card: Card(10, of: .club))
            }
            .padding()
        }
    }
}

struct PokerTableView_Previews: PreviewProvider {
    static var previews: some View {
        PokerTableView()
    }
}

enum CardSuit {
    
    case spade
    case club
    case heart
    case diamond
    
    var color: Color {
        switch self {
        case .spade:
            return .black
        case .club:
            return .black
        case .heart:
            return .red
        case .diamond:
            return .red
        }
    }
    
    var str: String {
        switch self {
        case .spade:
            return "spade"
        case .club:
            return "club"
        case .heart:
            return "heart"
        case .diamond:
            return "diamond"
        }
    }
}

struct Card {
    let cardValue: Int
    let cardSign: String
    let suit: CardSuit
    
    init(_ cardValue: Int, of cardSuit: CardSuit) {
        self.cardValue = cardValue
        self.suit = cardSuit
        
        switch cardValue {
        case 2...10:
            self.cardSign = "\(cardValue)"
        case 11:
            self.cardSign = "J"
        case 12:
            self.cardSign = "Q"
        case 13:
            self.cardSign = "K"
        default:
            self.cardSign = "A"
        }
        
    }
}

struct CardView: View {
    
    let card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color("paleTan"))
            
            
            GeometryReader { geo in
                VStack {
                    
                    CardBanner(card: card)
                    
                    Spacer()
                    
                    CardBanner(card: card)                    .rotationEffect(Angle(degrees: 180))
                }
                .font(.system(size: geo.size.height / 18, weight: .bold, design: .serif))
                .foregroundColor(card.suit.color)
            }
        }
        .aspectRatio(1 / 1.5, contentMode: .fit)
    }
}

struct CardBanner: View {
    let card: Card
    
    var body: some View {
        HStack {
            CardLogo(card: card)
            Spacer()
            CardLogo(card: card)
        }
    }
}

struct CardLogo: View {
    let card: Card
    
    var body: some View {
        VStack {
            Text(card.cardSign)
            Image(systemName: "suit.\(card.suit.str).fill")
        }
        .padding()
    }
}
