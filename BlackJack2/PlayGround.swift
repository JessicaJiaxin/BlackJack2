//
//  PlayGround.swift
//  BlackJack2
//
//  Created by Jiaxin Li on 2/26/15.
//  Copyright (c) 2015 Jiaxin Li. All rights reserved.
//

import Foundation
class PlayGround: NSObject {
    
    private let MAX_GAME_TURN = 5
    private let dealer = Dealer(title: "Dealer")
    
    private var gamers: [Gamer]!
    private var deck: Deck!
    
    private var gameTurn = 1
    
    init(numOfPlayers: Int, numOfDecks: Int) {
        
        gamers = [Gamer]()
        deck = Deck(numOfDecks: numOfDecks)
        
        gamers.append(dealer)	//first is Dealer
        
        for index in 1...numOfPlayers {
            gamers.append(Player(title: "Player \(index)"))
        }
    }
    
    func getDeck() -> Deck {
        return deck
    }
    
    func getDealerFirstCard() -> Card {
        return dealer.cards[0]
    }
    
    func getDealer() -> Dealer {
        return dealer
    }
    
    func getNotInsurancePlayer() -> Player? {
        for index in 1...(gamers.count - 1) {
            let player = gamers[index] as Player
            if !player.hasInsurance {
                return player
            }
        }
        
        return nil
    }
    
    func getAvailablePlayer() -> Player? {
        for index in 1...(gamers.count - 1) {
            let player = gamers[index] as Player
            if !player.isTurnOver {
                return player
            }
        }
        
        return nil
    }
    
    func existValidPlayers() -> Bool {
        for index in 1...(gamers.count - 1) {
            let player = gamers[index] as Player
            if player.gameType != .Lose {
                return true
            }
        }
        
        return false
    }
    
    func getNotBetPlayer() -> Player? {
        for index in 1...(gamers.count - 1) {
            let player = gamers[index] as Player
            if !player.isBeted {
                return player
            }
        }
        
        return nil
    }
    
    func getGamers() -> [Gamer] {
        return gamers
    }
    
    func initGame() {
        for gamer in gamers {
            gamer.initCards(deck)
        }
    }
    
    func dealerWin() {
        for index in 1...(gamers.count - 1) {
            let player = gamers[index] as Player
            if player.gameType != .Lose {
                player.gameType = .Lose
                player.loseGame()
            }
        }
    }
    
    func validPlayerWin() {
        for index in 1...(gamers.count - 1) {
            let player = gamers[index] as Player
            if player.gameType != .Lose {
                player.gameType = .Win
                player.winGame()
            }
        }
    }
    
    func comparePlayerWinOrLose() {
        for index in 1...(gamers.count - 1) {
            let player = gamers[index] as Player
            
            print("<\(player.cardSum), \(dealer.cardSum)")
            
            if player.gameType != .Lose {
                if player.cardSum > dealer.cardSum {
                    player.gameType = .Win
                    player.winGame()
                }else if player.cardSum < dealer.cardSum {
                    player.gameType = .Lose
                    player.loseGame()
                }else if dealer.cardSum == dealer.BLACK_JACK && player.cards.count == 2 && player.cards.count == dealer.cards.count {	//black Jack
                    player.gameType = .Tie
                }else {
                    player.gameType = .Lose
                    player.loseGame()
                }
            }
        }
    }
    
    func insuranceAndBlackJack() {
        dealer.canShow = true
        
        var isBlackJack = false
        
        if dealer.cardSum == dealer.BLACK_JACK && dealer.cards.count == 2 {
            isBlackJack = true
        }
        
        for index in 1...(gamers.count - 1) {
            let player = gamers[index] as Player
            if player.hasInsurance && isBlackJack {	//is black jack and player who has insurance win
                player.gameType = .Win
                player.winGame()
            }else if player.hasInsurance && !isBlackJack {// is not black jack and player who has insurance lose
                player.gameType = .Lose
                player.loseInsurance()
            }
        }
    }
    
    func newGame() {
        dealer.turnOver()
        for index in 1...(gamers.count - 1) {
            let player = gamers[index] as Player
            player.turnOver()
        }
    }
    
    func endGame() -> String {
        //if 5 turn, shuffle
        if gameTurn == MAX_GAME_TURN {
            deck.shuffleCards()
            gameTurn = 1
        }else {
            gameTurn++
        }
        
        if gamers[0].gameType == .Win {
            return "Dealer win"
        }else {
            var result = ""
            for index in 1...(gamers.count - 1) {
                if gamers[index].gameType == .Win {
                    result += gamers[index].title
                    result += ","
                }
            }
            result += "Win"
            
            return result
        }
    }
    
    func kickOutNoMoneyPlayer() -> Int? {
        var position = -1
        
        var isDealer = false
        var index = 1
        
        while index < gamers.count {
            let player = gamers[index] as Player
            if player.money <= 0 {
                position = index
                break
            }
            index++
        }
        
        if position != -1 {
            gamers.removeAtIndex(position)
            return position
        }else {
            return nil
        }
    }
}
