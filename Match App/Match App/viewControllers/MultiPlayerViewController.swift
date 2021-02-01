//
//  ViewController.swift
//  Match App
//
//  Created by dhananjay pratap singh on 24/11/2020.
//

import UIKit

class MultiPlayerViewController: UIViewController , UICollectionViewDelegate ,UICollectionViewDataSource {
   
  
    @IBOutlet weak var collectionView2: UICollectionView!
    
    @IBOutlet weak var timerLabel2: UILabel!
   
    @IBOutlet weak var player1Score: UILabel!
    
    @IBOutlet weak var player2Score: UILabel!
    
    @IBOutlet weak var turn: UILabel!
    
    @IBOutlet weak var turnsLeft: UILabel!
    
    var firstCardFlip: IndexPath?
    
    var model = CardModel()
    
    var cardArray = [Card]()

    var score1 = 0
    
    var score2 = 0
    
    var attemptsLeft = 60 // since two cards filled is counted as a single turn
    
    
    var playerOneTurn = false
    var playerTwoTurn = false
    
    var winner = ""
    
    var cardsRemaining = 30
    
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Call getCards methods from card model class
        cardArray = model.getCards()
        
        collectionView2.delegate = self
        collectionView2.dataSource = self
        
        turn.text = "Player 1 turn"
        
        playerOneTurn = true
        
        
    }
    
    // called when the view is presented to the user
    override func viewDidAppear(_ animated: Bool) {
        
        SoundManager.playSound(.shuffle)
        
        turnsLeft.text = "Turns Left: 30"
        
    }
    
    
    // protocol methods
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // reusing the cell
        let cell = collectionView2.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell2
        
        // get the card
        let card = cardArray[indexPath.row]
        
        // set the cell
        cell.setCard(card)
        
        return cell
        
    }
    
    // cell is tapped
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            // check if there is any attempt left
            
            turnsLeft.text = " Turns Left: \(attemptsLeft/2)"
            
            attemptsLeft = attemptsLeft - 1
            
        
        
        if attemptsLeft == 0 || cardsRemaining == 0{
            
            if score1 > score2 {
                
                winner = "Player 1 Wins"
            }
            
            else if score2 > score1 {
                
                winner = "Player 2 Wins"
            }
            
            else{
                
                winner = "It's a draw"
            }
            
            
            showAlert("Game Ended",winner)
            
        }
           
            
            
            // get the cell user has selected
            let cell = collectionView2.cellForItem(at: indexPath) as! CardCollectionViewCell2
            // get the card user has selected
            let card = cardArray[indexPath.row]

            
            if card.isFlipped == false && card.isMatched == false {
                
                cell.flip()
                card.isFlipped = true
                
                SoundManager.playSound(.flip)
                
                // determine if it is the first card flipped or the second
                if firstCardFlip == nil{
                    
                    firstCardFlip = indexPath
                }
                else{
                    // second card flipped
                    
                    if playerOneTurn == true{
                        
                        playerOneTurn = false
                        turn.text = "Player 2 turn"
                    }
                    else if playerOneTurn == false{
                        
                        playerOneTurn = true
                        turn.text = "Player 1 turn"
                        
                    }
                    
                    
                    checkForMatch_two(indexPath)
                    
        
                }
            }
            
        }
    
    func checkForMatch_two(_ secondCardFlip:IndexPath) {
        
        // get the cell for both cells
        
        
        let cellOne = collectionView2.cellForItem(at: firstCardFlip!) as? CardCollectionViewCell2
        
        let cellTwo = collectionView2.cellForItem(at: secondCardFlip) as? CardCollectionViewCell2
        
        // get the cards for the two cards that were revealed
        
        let cardOne = cardArray[firstCardFlip!.row]
        let cardTwo = cardArray[secondCardFlip.row]
        
        //compare cards
        
        if cardOne.imageName == cardTwo.imageName{
            
            // it's a match
            
            SoundManager.playSound(.match)
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // remove from grid
            
            cellOne?.remove()
            cellTwo?.remove()
            
            cardsRemaining -= 2
            
            if playerOneTurn == true{
                
                playerOneTurn = false
                turn.text = "Player 2 turn"
                score2 = score2 + 1
                player2Score.text = String("Player 2: \(score2)")
                
            }
            else if playerOneTurn == false{
            
                playerOneTurn = true
                turn.text = "Player 1 turn"
                score1 = score1 + 1
                player1Score.text = String("Player 1: \(score1)")
                
                
            }
            
            
        }
        
        else{
            
            SoundManager.playSound(.nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //flip back
            
            
            
            cellOne?.flipBack()
            cellTwo?.flipBack()
        }
        
        if cellOne == nil{
            collectionView2.reloadItems(at: [firstCardFlip!])
        }
        
        firstCardFlip = nil
        
    
    }
   
    func showAlert(_ title:String, _ message:String) {
        
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler:{ action in self.performSegue(withIdentifier: "options", sender:self) })
        
        alert.addAction(alertAction)
        
       
        present(alert, animated: true, completion: nil)
    }
    

  
}// end of view controller class
      
    
   

 


