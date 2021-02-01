//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by dhananjay pratap singh on 24/11/2020.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card){
        
        // keep track of the card that gets passed in
        self.card = card
        
        
        // if the cards hasn't been matched, make the image views invisible
        if card.isMatched == true{
            
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        }
        
        // if the cards hasn't been matched, make the image views  visible
        else{
            
            backImageView.alpha = 1
            frontImageView.alpha = 1
            
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        // determine the state of the card
        
        if card.isFlipped == true{
            
            // the front view is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
            
        }
        
        else{
            
            // back view is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
            
        }
    
    }
    
    func flip(){
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
        
        
    }
    
    func flipBack(){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
            
        }
        
       
    }
    
    func remove() {
        
        //removes both images from being visible
        
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.5, options: .curveEaseInOut,animations: {
            
            self.frontImageView.alpha = 0
            
        }, completion: nil)
            
    }
} 
