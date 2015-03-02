//
//  Card.swift
//  BlackJack2
//
//  Created by Jiaxin Li on 2/26/15.
//  Copyright (c) 2015 Jiaxin Li. All rights reserved.
//


import Foundation

enum Suit: Int{
    case Spades = 1, Hearts, Diamonds, Clubs
    func simpleDescription() -> String {
        switch self {
        case .Spades:
            return "spades"
        case .Hearts:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        }
    }
}

enum Rank: Int {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    func simpleDescription() -> String {
        switch self {
        case .Ace:
            return "ace"
        case .Jack:
            return "jack"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}

class Card : NSObject {
    var suit : Suit!
    var rank : Rank!
    var value : Int!
    var isUsed  = false;
    
    init(suit: Suit, rank: Rank) {
        super.init()
        
        self.suit = suit
        self.rank = rank
        
        switch self.rank.rawValue {
        case 1:
            self.value = 11
            break
        case 10...13:
            self.value = 10
            break
        default:
            self.value = self.rank.rawValue
        }
        
    }
    
    func resetCard() {
        if value == 1 {
            value = 11
        }
        isUsed = false
    }
}
