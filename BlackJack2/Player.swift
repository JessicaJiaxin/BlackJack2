//
//  Player.swift
//  BlackJack2
//
//  Created by Jiaxin Li on 2/26/15.
//  Copyright (c) 2015 Jiaxin Li. All rights reserved.
//

import Foundation
class Player : Gamer {
    var isTurnOver = false
    var isBeted = false
    var hasInsurance = false
    var money = 100
    var currentBet = 0
    
    override func hitCard(deck: Deck) -> Bool {
        super.hitCard(deck)
        
        findAce()
        
        //bust
        if cardSum > BLACK_JACK {
            isTurnOver = true
            gameType = GameType.Lose
            return false
        }
        
        return true
    }
    
    override func getTitle() -> String {
        var result = super.getTitle()
        result += "\t Money: \(money) \t Bet: \(currentBet)"
        
        if hasInsurance {
            result += " [I] "
        }
        
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
    
    override func getCardStatus() -> String {
        if cardStatus.count == 0 {
            return ""
        }
        return (super.getCardStatus() + "\t Sum:\(cardSum)")
    }
    
    override func turnOver() {
        super.turnOver()
        isTurnOver = false
        isBeted = false
        hasInsurance = false
        currentBet = 0
    }
    
    func winGame() {
        money += currentBet
    }
    
    func loseGame() {
        money -= currentBet
    }
    
    func loseInsurance() {
        money -= (currentBet / 2)
    }
}
