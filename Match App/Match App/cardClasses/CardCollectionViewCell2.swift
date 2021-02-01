//
//  CardCollectionViewCell2.swift
//  Match App
//
//  Created by dhananjay pratap singh on 28/11/2020.
//

import UIKit

class CardCollectionViewCell2: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView2: UIImageView!
    
    @IBOutlet weak var backImageView2: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card){
        
        // keep track of the card that gets passed in
        self.card = card
        
        
        // if the cards hasn't been matched, make the image views invisible
        if card.isMatched == true{
            
            backImageView2.alpha = 0
            frontImageView2.alpha = 0
            
            return
        }
        
        // if the cards hasn't been matched, make the image views  visible
        else{
            
            backImageView2.alpha = 1
            frontImageView2.alpha = 1
            
        }
        
        frontImageView2.image = UIImage(named: card.imageName)
        
        // determine the state of the card
        
        if card.isFlipped == true{
            
            // the front view is on top
            UIView.transition(from: backImageView2, to: frontImageView2, duration: 0, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
            
        }
        
        else{
            
            // back view is on top
            UIView.transition(from: frontImageView2, to: backImageView2, duration: 0, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
            
        }
    
    }
    
    func flip(){
        
        UIView.transition(from: backImageView2, to: frontImageView2, duration: 0.3, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
        
        
    }
    
    func flipBack(){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            
            UIView.transition(from: self.frontImageView2, to: self.backImageView2, duration: 0.3, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
            
        }
        
       
    }
    
    func remove() {
        
        //removes both images from being visible
        
        backImageView2.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.5, options: .curveEaseInOut,animations: {
            
            self.frontImageView2.alpha = 0
            
        }, completion: nil)
            
    }
    
}
