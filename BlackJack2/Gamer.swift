//
//  Gamer.swift
//  BlackJack2
//
//  Created by Jiaxin Li on 2/26/15.
//  Copyright (c) 2015 Jiaxin Li. All rights reserved.
//

import Foundation

enum GameType: Int {
    case Win = 0, Lose, Tie, Out, None
}

class Gamer {
    let BLACK_JACK = 21
    
    var cards = [Card]()
    var cardSum = 0
    var cardStatus = [String]()
    var gameType: GameType!
    var title: String
    
    var indexPath: NSIndexPath!
    
    init(title: String){
        self.title = title
        self.gameType = .None
    }
    
    func initCards(deck: Deck) {
        cards.append(deck.getRandomCard())
        cards.append(deck.getRandomCard())
        cardSum += cards[0].value
        cardSum += cards[1].value
        cardStatus.append(convertCardValue(cards[0]))
        cardStatus.append(convertCardValue(cards[1]))
        
        findAce()
    }
    
    func hitCard(deck: Deck) -> Bool {
        cards.append(deck.getRandomCard())
        cardSum += cards[cards.count - 1].value
        cardStatus.append(convertCardValue(cards[cards.count - 1]))
        
        return true
    }
    
    func findAce() {
        if cardSum > BLACK_JACK {
            for card in cards {
                if card.value == 11 {
                    card.value = 1
                    cardSum -= 10
                    break
                }
            }
        }
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getCardStatus() -> String {
        return cardStatus.description
    }
    
    func convertCardValue(card: Card) -> String {
        if card.value == 11 || card.value == 1 {
            return " A"
        }else {
            return " \(card.value)"
        }
    }
    
    func turnOver() {
        cards.removeAll(keepCapacity: false)
        cardSum = 0
        cardStatus.removeAll(keepCapacity: false)
        gameType = GameType.None
    }
}
