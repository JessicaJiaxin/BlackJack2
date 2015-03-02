//
//  PreGameViewController.swift
//  BlackJack2
//
//  Created by Jiaxin Li on 2/26/15.
//  Copyright (c) 2015 Jiaxin Li. All rights reserved.
//

import UIKit

class PreGameViewController: UIViewController {
    
    @IBOutlet var players: UILabel!
    @IBOutlet var decks: UILabel!
    @IBOutlet var numOfPlayers: UITextField!
    @IBOutlet var numOfDecks: UITextField!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startGame" {
            //judge if players are less than 6
            if numOfPlayers.text.toInt() > 6 {
                let alert = createAlertController("Warning", msg: "number of players must less than 6!")
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            if numOfPlayers.text.toInt() < 2 {
                let alert = createAlertController("Warning", msg: "number of players must more than 1!")
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            if numOfDecks.text.toInt() < 1 {
                let alert = createAlertController("Warning", msg: "You must choose at least 1 deck!")
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            
            var viewController = segue.destinationViewController as GameViewController
            var playGround = PlayGround(numOfPlayers: numOfPlayers.text.toInt()!, numOfDecks: numOfDecks.text.toInt()!)
            
            viewController.setPlayGround(playGround)
        }
    }
    
    func createAlertController(title: String, msg: String) -> UIAlertController {
        let alertViewController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alertViewController.addAction(okAction)
        
        return alertViewController;
    }

}
