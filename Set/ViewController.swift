//
//  ViewController.swift
//  Set
//
//  Created by Andi Maroge on 11/5/18.
//  Copyright © 2018 Andi Maroge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var addThreeCardsButton: UIButton! {
        didSet {
            addThreeCardsButton.layer.cornerRadius = 5
        }
    }
    //initializes the set class with the maximum number of cards in the game of set with maxCardButtonCount
    lazy var game = Set(numberOfCards: maxCardButtonCount)
    var cardButtons = [UIButton]()
    //initial number of buttons in the UI
    var initialButtonCount = 12
    var currentButtonCount = 0
    //maximum number of cards in the game
    var maxCardButtonCount = 81
    //maximum number of cards in the view at a time
    let maxNumberOfButtonsOnView = 24
    //button size
    var buttonSize = CGSize(width: 60, height: 65)
    //selected buttons array
    lazy var selectedButtons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGameCards()
        loadCards()
        
        for index in 0..<game.cards.count {
            let card = game.cards[index]
            print("index: \(index) shape:\(card.shape) number: \(card.numberOfShapes) id: \(card.identifier) shapeColor: \(card.shapeColor)")
        }
        
        print(game.cards.count)
    }
    //when the user touches a card on the UI
    @IBAction func touchCard(_ sender: UIButton) {
        var cardsMatch = false
        
        //select and deselect button
        if selectedButtons.count < 3 {
            //if the button is not selected, select the button
            if sender.isSelected == false {
                sender.isSelected = true
                sender.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                selectedButtons.append(sender)
            }
                //if the button is selected, deselect the button
            else {
                sender.isSelected = false
                sender.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                selectedButtons.removeLast()
            }
        }
        //when the number of buttons in the array is equal to 3, check if cards match
        if selectedButtons.count == 3{
            var cardsFromModel = [Card]()
            for index in 0..<selectedButtons.count {
                let nextCard = selectedButtons[index]
                cardsFromModel.append(game.cards[nextCard.tag - 1])
            }
            cardsMatch = game.isSelectionASet(cardsSelected: cardsFromModel)
        }
        //if cards do match, then remove the cards from view
        if cardsMatch {
            deselectSelectedButtons()
            for index in 0..<selectedButtons.count {
                let nextCard = selectedButtons[index]
                nextCard.removeFromSuperview()
            }
            selectedButtons.removeAll()
        }
        
        //when 3 buttons are not matched and the user selects another button not selected previously, deselect and remove all buttons
        //previously selected, and select the new unselected button
        if !sender.isSelected, selectedButtons.count == 3, !cardsMatch{
            deselectSelectedButtons()
            selectedButtons.removeAll()
            selectedButtons.append(sender)
            sender.isSelected = true
            sender.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
    }
    
    
    //loads the buttons in the UI
    private func loadCards(){
        
        for index in 0...maxNumberOfButtonsOnView{
            
            let button = UIButton(type: .roundedRect)
            button.tag = game.cards[index].identifier
            print(game.cards[index].identifier)
            var buttonCoordinate = CGPoint()
            if cardButtons.count > 0 {
                buttonCoordinate = getCoordinateWhereButtonDoesNotOverlap(this: button)
            }
            else {
                buttonCoordinate = Coordinates().randomCoordinatesWithinBoundsOfView(of: self.view.frame.maxX, and: self.view.frame.maxY, of: Int(buttonSize.width), and: Int(buttonSize.height))
            }
            
            //button properties settings
            button.frame = CGRect(
                x: buttonCoordinate.x,
                y: buttonCoordinate.y,
                width: buttonSize.width,
                height: buttonSize.height)
            let buttonTitle = getNSAttributedString(cardAt: index)
            button.setAttributedTitle(buttonTitle, for: .normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            button.addTarget(self, action:#selector(self.touchCard(_:)), for: .touchUpInside)
            button.layer.borderWidth = 2; button.layer.cornerRadius = 5; button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            //add button to the setCards array
            cardButtons.append(button)
            //increment button count as more are added
            currentButtonCount += 1
            //add initial buttons to the view. Initial button count is 12
            if index < initialButtonCount {
                view.addSubview(button)
            }
        }
    }
    //set the game cards
    private func setGameCards(){
        
        var tempShapeColor = Card.Color.all, tempShape = Card.Shapes.all, tempNumberOfShapes = Card.Number.all, tempShading = Card.Shading.all
        var colorCounter = 0, shapeCounter = 0 , numberOfShapesCounter = 0, shadingCounter = 0
        
        for index in 0..<game.cards.count {
            
            if  (index > 1 && index % 9 == 0){
                shadingCounter += 1
                shapeCounter += 1
            }
            if index > 1, index % 3 == 0 {
                colorCounter += 1
            }
            if numberOfShapesCounter > 2 { numberOfShapesCounter = 0 }
            if colorCounter > 2 { colorCounter = 0}
            if shapeCounter > 2 { shapeCounter = 0 }
            if shadingCounter > 2 { shadingCounter = 0 }
            
            game.cards[index].shape = tempShape[shapeCounter].rawValue
            game.cards[index].numberOfShapes = tempNumberOfShapes[numberOfShapesCounter].rawValue
            game.cards[index].shapeColor = tempShapeColor[colorCounter].rawValue
            game.cards[index].shading = tempShading[shadingCounter].rawValue
            
            //change number on every card
            numberOfShapesCounter += 1
        }
    }
    //adds three more cards to the UI with the Add Three More cards button
    @IBAction func addThreeMoreCards(_ sender: UIButton) {
        
        for _ in 1...3 {
            if currentButtonCount > initialButtonCount{
                let randomInteger = Int.random(in: 12..<cardButtons.count)
                let button = cardButtons.remove(at: randomInteger)
                print(button.tag)
                view.addSubview(button)
                currentButtonCount -= 1
            }
            else{
                sender.isEnabled = false
                sender.alpha = 0.10
            }
        }
    }
    
    //a reusable function to find the area where a button does not overlap another one before it is viewed in the UI
    private func getCoordinateWhereButtonDoesNotOverlap(this button: UIButton) -> CGPoint{
        //inner function for checking if UI button overlaps
        func doesButtonOverlapOnAnyButtonInUI() -> Bool{
            for index in 0..<cardButtons.count {
                let buttonInView = cardButtons[index]
                if button.frame.intersects(buttonInView.frame){
                    return true
                }
            }
            return false
        }
        var buttonOverlaps = true
        var buttonCoordinate = CGPoint()
        
        while(buttonOverlaps == true){
            buttonCoordinate = Coordinates().randomCoordinatesWithinBoundsOfView(
                of: self.view.frame.maxX,
                and: self.view.frame.maxY,
                of: Int(buttonSize.width),
                and: Int(buttonSize.height))
            button.frame = CGRect(x: buttonCoordinate.x,
                                  y: buttonCoordinate.y,
                                  width: buttonSize.width,
                                  height: buttonSize.height)
            buttonOverlaps = doesButtonOverlapOnAnyButtonInUI()
        }
        return buttonCoordinate
    }
    //a reusable function to deselect the selected buttons
    private func deselectSelectedButtons(){
        for index in 0..<selectedButtons.count {
            selectedButtons[index].isSelected = false
            selectedButtons[index].layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    //get the NSAttributed String for the card
    private func getNSAttributedString(cardAt index: Int ) -> NSAttributedString {
        let card = game.cards[index]
        let shapeNSattString = card.shape
        let attributesOfNSSattString: [NSAttributedString.Key: Any] = [
            .foregroundColor: game.cards[index].shapeColor]
        let attributedStringOfCard = NSAttributedString(string: shapeNSattString, attributes: attributesOfNSSattString)
        return attributedStringOfCard
    }
}
