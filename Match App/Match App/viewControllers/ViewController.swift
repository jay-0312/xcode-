//
//  ViewController.swift
//  Match App
//
//  Created by dhananjay pratap singh on 24/11/2020.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstCardFilpped:IndexPath?

    var attemptsLeft = 60 // since two cards filled is counted as a single turn
    
    var score = 0
    
    var newHighScore = 0
    
    var cardsRemaining = 30
    
    
    
    // saving highscore
    
    let storage = UserDefaults.standard
    
    
  
//______________________________________________________________________________________________
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Call getCards methods from card model class
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        newHighScore = storage.integer(forKey: "hs")
        highScoreLabel.text = String("HIGHSCORE: \(newHighScore)")
       
    }
    
//______________________________________________________________________________________________

    // called when the view is presented to the user
    override func viewDidAppear(_ animated: Bool) {
        
        SoundManager.playSound(.shuffle)
    }
    
//______________________________________________________________________________________________

    
    // Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
//______________________________________________________________________________________________

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a cardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // get the card the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        // set that card for the cell
        cell.setCard(card)
        
        return cell
    }
    
//______________________________________________________________________________________________

        
    // cell is tapped
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            timeLabel.text = "Attempts Left: \(attemptsLeft/2)"
        
            attemptsLeft = attemptsLeft - 1
        
        // check if there is any attempt left
        if attemptsLeft == 0 || cardsRemaining == 0{
            
            showAlert("Game Ended","Score:\(score)")
            
        }
            
        
        // get the cell user has selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // get the card user has selected
        let card = cardArray[indexPath.row]
         
        if card.isFlipped == false && card.isMatched == false {
            
            // flip the card
            cell.flip()
            
            // play flio sound
            SoundManager.playSound(.flip)
            
            card.isFlipped = true
            
            // determine if it's the first or the second card being flipped over
            
            if firstCardFilpped == nil{
                
                firstCardFilpped = indexPath
            }
            
            else{
                
                // Second card is being flipped over
                
                // perform the matching logic
                checkForMatches(indexPath)
            }
        }
    }
    
//______________________________________________________________________________________________

    
    // MARK: - Game logic method
    
    func checkForMatches(_ secondCardFlipped:IndexPath)  {
        
        // get the cells for the two cards that were revealed
        
        let cardOneCell = collectionView.cellForItem(at: firstCardFilpped!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondCardFlipped) as? CardCollectionViewCell
        
        // get the cards for the two cards that were revealed
        
        let cardOne = cardArray[firstCardFilpped!.row]
        let cardTwo = cardArray[secondCardFlipped.row]
        
        // compare two cards
        if cardOne.imageName == cardTwo.imageName{
            
            score = score + 1
            
            scoreLabel.text = "Score: \(score)"
            
            if score > newHighScore {
                
                newHighScore = score
                
                newHighScoreAchieved()
                
                highScoreLabel.textColor = UIColor.white
                highScoreLabel.backgroundColor = UIColor.black
                
                highScoreLabel.text = String("HIGHSCORE: \(newHighScore)")
                
                storage.set(newHighScore, forKey: "hs")
                
            }
        
            // it's a match
            
            // play sound for matched
            
            SoundManager.playSound(.match)
            
            // set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            cardsRemaining -= 2
           
        }
        
        else{
            
            // it's not a match
            
            // play sound for not matched
            
            SoundManager.playSound(.nomatch)
            
            // set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // flip the cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // tell the collection view to reload the cell of the first card if it's nil
        if cardOneCell == nil{
            
            collectionView.reloadItems(at: [firstCardFilpped!])
        }
        
        // reset the property that tracks the first card flipped
        firstCardFilpped = nil
    }
    
 //______________________________________________________________________________________________

    func showAlert(_ title:String, _ message:String) {
        
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler:{ action in self.performSegue(withIdentifier: "showOptions", sender:self) })
        
        alert.addAction(alertAction)
        
       
        present(alert, animated: true, completion: nil)
    }

    
    // if the user hits a new high score
    
    @IBOutlet weak var message: UIView!
    
     func newHighScoreAchieved() {
      
       message.backgroundColor = UIColor.purple
     }
    
}
