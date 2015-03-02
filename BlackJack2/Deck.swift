//
//  Deck.swift
//  BlackJack2
//
//  Created by Jiaxin Li on 2/26/15.
//  Copyright (c) 2015 Jiaxin Li. All rights reserved.
//


import Foundation

class Deck : NSObject {
    
    var cards : [Card]!
    
    override init() {
        super.init()
        
        cards = createCards()
    }
    
    init(numOfDecks: Int) {
        super.init()
        cards = [Card]()
        for index in 1...numOfDecks {
            cards! += self.createCards()
        }
    }
    
    private func createCards() -> [Card] {
        var results: [Card] = [Card]()
        
        for suit in 1...4 {
            for rank in 1...13 {
                var card = Card(suit: Suit(rawValue: suit)!, rank: Rank(rawValue: rank)!)
                
                results.append(card)
            }
        }
        
        return results
    }
    
    func shuffleCards() {
        for card in cards {
            card.resetCard()
        }
    }
    
    func getRandomCard() -> Card {
        let cardNumber = getCardNumber()
        let card = cards[cardNumber]
        card.isUsed = true
        
        return card
    }
    
    func getCardNumber() -> Int {
        var isFound = false
        
        while !isFound {
            let number = Int(arc4random())
            let card = cards[number % cards.count]
            if card.isUsed == false {
                return number % cards.count
            }
        }
    }
}