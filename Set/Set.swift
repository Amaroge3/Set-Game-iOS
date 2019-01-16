//
//  setModel.swift
//  Set
//
//  Created by Andi Maroge on 11/6/18.
//  Copyright © 2018 Andi Maroge. All rights reserved.
//

import Foundation
import UIKit

class Set {
    //cards in the game
    var cards = [Card]()
    
    //initializes the cards and shuffles them
    init(numberOfCards: Int){
        
        for _ in 0..<numberOfCards {
            let card = Card()
            cards.append(card)
        }
        
    }
    public func resetCardsForNewGame(){
        cards = []
        Card.identifierFactory = 0
    }
    //shuffle cards
    public func shuffle(){
        for index in 0..<cards.count {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            let tempArrayValueForSwitch = cards[index]
            cards[index] = cards[randomIndex]
            cards[randomIndex] = tempArrayValueForSwitch
        }
    }
   
    //if card.shape = card.shape = card.shape
    public func isSelectionASet(cardsSelected: [Card]) -> Bool {
        
        var sameShapeCount = 0, sameColorCount = 0, sameShadingCount = 0, sameNumberOfShapesCount = 0

        for index in 0..<cardsSelected.count - 1{
            
            let card = cardsSelected[index]
            let nextCard = cardsSelected[index + 1]
            
            if card.shape == nextCard.shape { sameShapeCount += 1 }
            if card.shapeColor.isEqual(nextCard.shapeColor)  { sameColorCount += 1 }
            if card.shading == nextCard.shading { sameShadingCount += 1 }
            if card.numberOfShapes == nextCard.numberOfShapes { sameNumberOfShapesCount += 1 }
            
            
        }
        
        if sameShapeCount == 1 || sameColorCount == 1 ||
            sameShadingCount == 1 || sameNumberOfShapesCount == 1 {
            return false
        }
        return true
    }
    public func removeCardFromModel(with identifier: Int) {
        for index in 0..<cards.count {
            if identifier == cards[index].identifier {
                cards.remove(at: index)
            }
        }
    }
    //get methods for different attributes of cards
    public func getColorOfCard(buttonTag tag: Int) -> UIColor {
        return cards[tag].shapeColor
    }

    public func getShadingOfCard(buttonTag tag: Int) -> Card.Shading {
        return cards[tag].shading
    }
    public func getNumberOfShapesOfCard(buttonTag tag: Int) -> Card.NumberOfShapes {
        return cards[tag].numberOfShapes
    }
    public func getCardIdentifier(buttonTag index: Int) -> Int {
        return cards[index].identifier
    }
}
