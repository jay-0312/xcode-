//
//  CardModel.swift
//  Match App
//
//  Created by dhananjay pratap singh on 24/11/2020.
//

import Foundation

class CardModel{
    
    func getCards() -> [Card]{
        
        // declare an array to store cards we have already generated
        var generatedNumbersArray = [Int]()
        
        // Declare an array to store generated cards
        var generateCardsArray = [Card]()
        
        // Randomly generate pair of cards
        while generatedNumbersArray.count < 15 {
            
            // Get a random number
            let randomNumber = arc4random_uniform(15) + 1
            
            // unique random number
            if generatedNumbersArray.contains(Int(randomNumber)) == false{
                
                // Create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                generateCardsArray.append(cardOne)
                
                // Create the second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generateCardsArray.append(cardTwo)
                
                // store thenumber in generatedNumbersArray
                
                generatedNumbersArray.append(Int(randomNumber))
                
            }
        }
        // Randomise the array
        
        for i in 0...generateCardsArray.count-1{
            
            let randomNumber = Int(arc4random_uniform(UInt32(generateCardsArray.count)))
            
            let temp = generateCardsArray[i]
            generateCardsArray[i] = generateCardsArray[randomNumber]
            generateCardsArray[randomNumber] = temp

        }
        // Return the array
        return generateCardsArray
        
    }
}
