//
//  Dealer.swift
//  BlackJack2
//
//  Created by Jiaxin Li on 2/26/15.
//  Copyright (c) 2015 Jiaxin Li. All rights reserved.
//

import Foundation

class Dealer: Gamer {
    var canShow = false
    
    //dealer turn
    func dealerTurn(deck: Deck) -> Bool {
        canShow = true
        
        while cardSum < 17 {
            hitCard(deck)
        }
        
        return cardSum > 21
    }
    
    override func turnOver() {
        super.turnOver()
        canShow = false
    }
    
    override func getTitle() -> String {
        var result = super.getTitle()
        
        if gameType != .None {
            if gameType == .Win {
                result += "\t [Win]"
            }else if gameType == .Lose {
                result += "\t [Lose]"
            }else if gameType == .Tie {
                result += "\t [Tie]"
            }
        }
        
        return result
    }
    
    // get dealer card status
    override func getCardStatus() -> String {
        if cardStatus.count == 0 {
            return ""
        }
        
        if !canShow {
            cardStatus[1] = "H"
            return (super.getCardStatus() + "\t Sum: Unknown")
        }else {
            cardStatus[1] = convertCardValue(cards[1])
            return (super.getCardStatus() + "\t Sum:\(cardSum)")
        }
    }
}
