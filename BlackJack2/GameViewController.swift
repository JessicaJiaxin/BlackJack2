//
//  GameViewController.swift
//  BlackJack2
//
//  Created by Jiaxin Li on 2/26/15.
//  Copyright (c) 2015 Jiaxin Li. All rights reserved.
//

import UIkit
class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var playGround: PlayGround!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var hintLabel: UILabel!
    @IBOutlet var currentStatus: UILabel!
    @IBOutlet var betInput: UITextField!
    
    @IBOutlet var betButton: UIButton!
    @IBOutlet var passButton: UIButton!
    @IBOutlet var hitButton: UIButton!
    @IBOutlet var insuranceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 10))
        
        //restart game
        let restartGameButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "backToPreGame")
        self.navigationItem.leftBarButtonItem = restartGameButton
        
        //new game
        let newGameButton = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "newGame")
        self.navigationItem.rightBarButtonItem = newGameButton
        
        betButton.enabled = true
        passButton.enabled = false
        hitButton.enabled = false
        insuranceButton.enabled = false
        
        betButton.addTarget(self, action: "betButtonClicked", forControlEvents: .TouchUpInside)
        passButton.addTarget(self, action: "passButtonClicked", forControlEvents: .TouchUpInside)
        hitButton.addTarget(self, action: "hitButtonClicked", forControlEvents: .TouchUpInside)
        insuranceButton.addTarget(self, action: "insuranceButtonClicked", forControlEvents: .TouchUpInside)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "tapClick")
        self.tableView.addGestureRecognizer(gestureRecognizer)
        
        newGame()
    }
    
    func tapClick() {
        betInput.resignFirstResponder()
    }
    
    func betButtonClicked() {
        if betInput.text.isEmpty {
            let alert = createAlertController("Warning", msg: "Bet cannot be null.")
            presentViewController(alert, animated: false, completion: nil)
            return
        }
        
        if let player = playGround.getNotBetPlayer() {
            
            if player.money < betInput.text.toInt()! {
                let alert = createAlertController("Warning", msg: "Bet should less than the money you have now.")
                presentViewController(alert, animated: false, completion: nil)
                return
            }
            
            player.currentBet = betInput.text.toInt()!
            player.isBeted = true
            self.tableView.reloadData()
        }
        
        if let nextPlayer = playGround.getNotBetPlayer() {
            self.hintLabel.text = nextPlayer.title + " start bet"
        }else {
            betInput.enabled = false
            betButton.enabled = false
            
            gameStart()
        }
    }
    
    func gameStart() {
        playGround.initGame()
        
        //game start
        hintLabel.text = "Game Start"
        self.passButton.enabled = true
        self.hitButton.enabled = true
        
        if playGround.getDealerFirstCard().value == 11 {	//insurance
            self.hintLabel.text = "Dealer has an Ace faced up, players can choose insurance."
            hitButton.enabled = false
            insuranceButton.enabled = true
        }else {
            self.hintLabel.text = "Player 1's turn"
            self.currentStatus.text = playGround.getGamers()[1].getCardStatus()
            self.tableView.selectRowAtIndexPath(playGround.getGamers()[1].indexPath, animated: true, scrollPosition: .None)
        }
    }
    
    func insuranceButtonClicked() {
        if let player = playGround.getNotInsurancePlayer() {
            player.hasInsurance = true
            self.hintLabel.text = player.title + "choose insurance"
            self.tableView.selectRowAtIndexPath(player.indexPath, animated: true, scrollPosition: .None)
            self.tableView.reloadData()
        }
        
        if let player = playGround.getNotInsurancePlayer() {
            //do nothing
        }else {
            //dealer see if it is a black jack or not
            self.insuranceButton.enabled = false
            self.hintLabel.text = "Dealer show cards"
            playGround.insuranceAndBlackJack()
            playGround.comparePlayerWinOrLose()
            
            endGame()
        }
    }
    
    func passButtonClicked() {
        if let player = playGround.getAvailablePlayer() {
            player.isTurnOver = true
        }
        
        findNextAvailablePlayer()
    }
    
    func hitButtonClicked() {
        if let player = playGround.getAvailablePlayer() {
            let result = player.hitCard(playGround.getDeck())
            self.currentStatus.text = player.getCardStatus()
            self.tableView.selectRowAtIndexPath(player.indexPath, animated: true, scrollPosition: .None)
            //bust
            if !result {
                player.loseGame()
            }
            
            self.tableView.reloadData()
        }
        
        findNextAvailablePlayer()
    }
    
    func findNextAvailablePlayer() {
        if let nextPlayer = playGround.getAvailablePlayer() {
            self.hintLabel.text = nextPlayer.title + "'s turn"
            self.currentStatus.text = nextPlayer.getCardStatus()
            self.tableView.selectRowAtIndexPath(nextPlayer.indexPath, animated: true, scrollPosition: .None)
        }else {
            //delaer turn
            dealerTurn()
        }
    }
    
    func dealerTurn() {
        self.hintLabel.text = "Dealer's turn"
        
        //check if exist valid player
        let result = playGround.existValidPlayers()
        let dealer = playGround.getDealer()
        dealer.canShow = true
        self.currentStatus.text = dealer.getCardStatus()
        self.tableView.selectRowAtIndexPath(dealer.indexPath, animated: true, scrollPosition: .None)
        
        if !result {	//all players are out
            self.hintLabel.text = "All players are bust, dealer win"
            dealer.gameType = .Win
            playGround.dealerWin()
        }else {
            let dealerBust = dealer.dealerTurn(playGround.getDeck())
            
            self.currentStatus.text = dealer.getCardStatus()
            
            if dealerBust {	//dealer bust
                dealer.gameType = .Lose
                playGround.validPlayerWin()
            }else {	//compare dealer card sum with rest player's card sum
                playGround.comparePlayerWinOrLose()
            }
        }
        
        self.tableView.reloadData()
        endGame()
    }
    
    func endGame() {
        let text = playGround.endGame()
        self.hintLabel.text = text
        self.currentStatus.text = "Press New Button to start a new game"
        
        hitButton.enabled = false
        passButton.enabled = false
        insuranceButton.enabled = false
    }
    
    func newGame() {
        self.hintLabel.text = playGround.getGamers()[1].title + " start bet"
        self.currentStatus.text = ""
        betInput.enabled = true
        betButton.enabled = true
        
        playGround.newGame()
        
        //kick out some players who runs out of money
        kickOutNoMoneyPlayer()
        
        self.tableView.reloadData()
    }
    
    func kickOutNoMoneyPlayer() {
        
        while let index = playGround.kickOutNoMoneyPlayer() {
            self.tableView.deleteSections(NSIndexSet(index: index), withRowAnimation: .Fade)
        }
    }
    
    func backToPreGame() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func setPlayGround(playGround: PlayGround) {
        self.playGround = playGround
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return playGround.getGamers().count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return (playGround.getGamers()[0] as Dealer).getTitle()
        }else {
            return (playGround.getGamers()[section] as Player).getTitle()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("gamer") as UITableViewCell
        
        if indexPath.section == 0 {
            let dealer = playGround.getGamers()[0] as Dealer
            dealer.indexPath = indexPath
            cell.textLabel?.text = dealer.getCardStatus()
        }else {
            let player = playGround.getGamers()[indexPath.section] as Player
            player.indexPath = indexPath
            cell.textLabel?.text = player.getCardStatus()
        }
        
        return cell
    }
    
    func createAlertController(title: String, msg: String) -> UIAlertController {
        let alertViewController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alertViewController.addAction(okAction)
        
        return alertViewController;
    }
}
