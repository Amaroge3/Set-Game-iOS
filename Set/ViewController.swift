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
            addThreeCardsButton.setNeedsDisplay()
            addThreeCardsButton.setNeedsLayout()
            
        }
    }
    //view that holds cards
    @IBOutlet weak var viewForAllCards: UIView!
        { didSet { viewForAllCards.layer.cornerRadius = 5 } }
    
    
    var grid = Grid(layout: Grid.Layout.dimensions(rowCount: 1, columnCount: 1))
    {
        didSet { viewForAllCards.setNeedsLayout();viewForAllCards.setNeedsDisplay() }
    }
    //initializes the set class with the maximum number of cards in the game of set with maxCardButtonCount
    lazy var game = Set(numberOfCards: maxCardCount)
    var cardButtons = [UIButton]()
    //initial number of buttons in the UI
    var initialCardCount = 12
    var currentCardCount = 0
    //maximum number of cards in the game
    var maxCardCount = 81
    //maximum number of cards in the view at a time
    let maxNumberOfButtonsOnView = 24
    //button size
    //selected buttons array
    lazy var selectedButtons = [UIButton]()
    var allCardViewsAvailableAndNotOnScreen = [CardView]()
    var cardViewsOnScreen = [CardView]()
    
    var numberOfRows = 4
    let numberOfCardsPerRow = 3
    override func viewDidLayoutSubviews() {
        
        updateGridAndCardViews()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setGameCards()
        //        loadCards()
        //
        
        for index in 0..<game.cards.count {
            let card = game.cards[index]
            print("index: \(index) shape:\(card.shape) number: \(card.numberOfShapes) id: \(card.identifier) shapeColor: \(card.shapeColor)")
        }
        print(game.cards.count)
        
        //        var card = CardView()
        //        card.layer.borderWidth = 2
        //        card.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //        grid = Grid(layout: Grid.Layout.dimensions(rowCount: 1, columnCount: 1))
        //        grid.frame = CGRect(x: self.view.bounds.minX + 16, y: self.view.bounds.minY + 50, width: self.view.bounds.width - 32, height: self.view.bounds.height - 100)
        ////        grid.aspectRatio = 20
        //        card.frame = CGRect(x: (grid[0]?.minX)!, y: (grid[0]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height)
        //        card.layer.cornerRadius = 2
        //         grid = Grid(layout: Grid.Layout.dimensions(rowCount: 1, columnCount: 3))
        //        grid.frame = CGRect(x: self.view.bounds.minX + 16, y: self.view.bounds.minY + 50, width: self.view.bounds.width - 32, height: self.view.bounds.height - 100)
        //        card.frame = CGRect(x: (grid[0]?.minX)!, y: (grid[0]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height)
        //
        //        var card2 = CardView()
        //        card2.layer.borderWidth = 2
        //        card2.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ////        card.frame = CGRect(x: (grid[0]?.minX)!, y: (grid[0]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height)
        //
        //        card2.frame = CGRect(x: (grid[1]?.minX)!, y: (grid[1]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height)
        ////        card.setNeedsDisplay()
        ////        card.setNeedsLayout()
        //
        //        var card3 = CardView()
        //
        //        card3.frame = CGRect(x: (grid[2]?.minX)!, y: (grid[2]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height)
        //        card3.sizeToFit()
        //
        //        card3.layer.borderWidth = 2
        //        card3.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //
        //        grid = Grid(layout: Grid.Layout.dimensions(rowCount: 2, columnCount: 3))
        //        grid.frame = CGRect(x: self.view.bounds.minX + 16, y: self.view.bounds.minY + 50, width: self.view.bounds.width - 32, height: self.view.bounds.height - 100)
        //        card3.frame = CGRect(x: (grid[2]?.minX)!, y: (grid[2]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height)
        //
        //        var card4 = CardView()
        //        card4.sizeToFit()
        //        card4.frame = CGRect(x: (grid[3]?.minX)!, y: (grid[3]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height)
        //
        //        view.addSubview(card)
        //        view.addSubview(card2)
        //        view.addSubview(card3)
        //        view.addSubview(card4)
        //print(grid.cellCount)
        
        //        card2.setNeedsDisplay()
        //        card2.setNeedsLayout()
        //        viewForAllCards.layoutIfNeeded()
        //viewForAllCards.updateConstraintsIfNeeded()
        //
        //        addThreeCardsButton.setNeedsDisplay()
        //        addThreeCardsButton.updateConstraintsIfNeeded()
        
        
        
        
        //        viewForAllCards.setNeedsUpdateConstraints()
        //        viewForAllCards.setNeedsDisplay()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadCardViews()
        
    }
    
    
    func loadCardViews() {
        
        grid = Grid(layout: Grid.Layout.dimensions(rowCount: numberOfRows, columnCount: numberOfCardsPerRow))
        
        grid.frame = CGRect(
            x: viewForAllCards.bounds.minX,
            y: viewForAllCards.bounds.minY,
            width: viewForAllCards.bounds.width,
            height: viewForAllCards.bounds.height)
        
        for index in 0..<maxCardCount {
            
            
            var cardFromModel = game.cards[index]
            var card = CardView()
            if index < initialCardCount {
//            card = CardView(frame: CGRect(x: (grid[index]?.minX)!, y: (grid[index]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height))
           card.frame = CGRect(x: (grid[index]?.minX)!, y: (grid[index]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height)
            }
           
                card.shape = cardFromModel.shape
            card.setColor(color: game.cards[index].shapeColor)
            
            switch cardFromModel.numberOfShapes {
                
            case .One:
                card.numberOfShapes = 1
                break
            case .Two:
                card.numberOfShapes = 2
                break
            case .Three:
                card.numberOfShapes = 3
                break
            }
            switch cardFromModel.shading {
                
            case .Solid:
                card.shadingAlpha = 1
                break
            case .Striped:
                card.shadingAlpha = 0.5
                break
            case .Open:
                card.shadingAlpha = 0
                break
            }
            card.layer.borderWidth = 2
            card.layer.cornerRadius = 5
            card.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            card.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            card.tag = CardView.createUniqueIdentifier()
            allCardViewsAvailableAndNotOnScreen.append(card)
            
            if index < initialCardCount {
                cardViewsOnScreen.append(card)
                viewForAllCards.addSubview(card)
            }
            else {
                allCardViewsAvailableAndNotOnScreen.append(card)
            }
        }
        
    }
    //when the user touches a card on the UI
    @IBAction func touchCard(_ sender: UIButton) {
        //        var cardsMatch = false
        //
        //        //select and deselect button
        //        if selectedButtons.count < 3 {
        //            //if the button is not selected, select the button
        //            if sender.isSelected == false {
        //                sender.isSelected = true
        //                sender.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        //                selectedButtons.append(sender)
        //            }
        //                //if the button is selected, deselect the button
        //            else {
        //                sender.isSelected = false
        //                sender.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //                selectedButtons.removeLast()
        //            }
        //        }
        //        //when the number of buttons in the array is equal to 3, check if cards match
        //        if selectedButtons.count == 3{
        //            var cardsFromModel = [Card]()
        //            for index in 0..<selectedButtons.count {
        //                let nextCard = selectedButtons[index]
        //                cardsFromModel.append(game.cards[nextCard.tag - 1])
        //            }
        //            cardsMatch = game.isSelectionASet(cardsSelected: cardsFromModel)
        //        }
        //        //if cards do match, then remove the cards from view
        //        if cardsMatch {
        //            deselectSelectedButtons()
        //            for index in 0..<selectedButtons.count {
        //                let nextCard = selectedButtons[index]
        //                nextCard.removeFromSuperview()
        //            }
        //            selectedButtons.removeAll()
        //        }
        //
        //        //when 3 buttons are not matched and the user selects another button not selected previously, deselect and remove all buttons
        //        //previously selected, and select the new unselected button
        //        if !sender.isSelected, selectedButtons.count == 3, !cardsMatch{
        //            deselectSelectedButtons()
        //            selectedButtons.removeAll()
        //            selectedButtons.append(sender)
        //            sender.isSelected = true
        //            sender.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        //        }
    }
    
    
    //loads the buttons in the UI
    private func loadCards(){
        
        //        for index in 0...maxNumberOfButtonsOnView{
        //
        //            let button = UIButton(type: .roundedRect)
        //            button.tag = game.cards[index].identifier
        //            print(game.cards[index].identifier)
        //            var buttonCoordinate = CGPoint()
        //            if cardButtons.count > 0 {
        //                buttonCoordinate = getCoordinateWhereButtonDoesNotOverlap(this: button)
        //            }
        //            else {
        //                buttonCoordinate = Coordinates().randomCoordinatesWithinBoundsOfView(of: self.view.frame.maxX, and: self.view.frame.maxY, of: Int(buttonSize.width), and: Int(buttonSize.height))
        //            }
        //
        //            //button properties settings
        //            button.frame = CGRect(
        //                x: buttonCoordinate.x,
        //                y: buttonCoordinate.y,
        //                width: buttonSize.width,
        //                height: buttonSize.height)
        //            let buttonTitle = getNSAttributedString(cardAt: index)
        //            button.setAttributedTitle(buttonTitle, for: .normal)
        //            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        //            button.addTarget(self, action:#selector(self.touchCard(_:)), for: .touchUpInside)
        //            button.layer.borderWidth = 2; button.layer.cornerRadius = 5; button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //
        //            //add button to the setCards array
        //            cardButtons.append(button)
        //            //increment button count as more are added
        //            currentButtonCount += 1
        //            //add initial buttons to the view. Initial button count is 12
        //            if index < initialButtonCount {
        //                view.addSubview(button)
        //            }
        //        }
    }
    //set the game cards
    private func setGameCards(){
        
        var tempShapeColor = Card.Color.all, tempShape = Card.Shapes.all, tempNumberOfShapes = Card.NumberOfShapes.all, tempShading = Card.Shading.all
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
            
            game.cards[index].shape = tempShape[shapeCounter]
            game.cards[index].numberOfShapes = tempNumberOfShapes[numberOfShapesCounter]
            game.cards[index].shapeColor = tempShapeColor[colorCounter].rawValue
            game.cards[index].shading = tempShading[shadingCounter]
            
            //change number on every card
            numberOfShapesCounter += 1
        }
    }
    //adds three more cards to the UI with the Add Three More cards button
    @IBAction func addThreeMoreCards(_ sender: UIButton) {
        
        numberOfRows += 1
        updateGridAndCardViews()
//        for _ in 1...3 {
//            if currentCardCount > initialCardCount{
//                let randomInteger = Int.random(in: 12..<cardButtons.count)
//                let button = cardButtons.remove(at: randomInteger)
//                print(button.tag)
//                view.addSubview(button)
//                currentCardCount -= 1
//            }
//            else{
//                sender.isEnabled = false
//                sender.alpha = 0.10
//            }
//        }
    }
    
    //    //a reusable function to find the area where a button does not overlap another one before it is viewed in the UI
    //    private func getCoordinateWhereButtonDoesNotOverlap(this button: UIButton) -> CGPoint{
    //        //inner function for checking if UI button overlaps
    //        func doesButtonOverlapOnAnyButtonInUI() -> Bool{
    //            for index in 0..<cardButtons.count {
    //                let buttonInView = cardButtons[index]
    //                if button.frame.intersects(buttonInView.frame){
    //                    return true
    //                }
    //            }
    //            return false
    //        }
    //        var buttonOverlaps = true
    //        var buttonCoordinate = CGPoint()
    //
    //        while(buttonOverlaps == true){
    //            buttonCoordinate = Coordinates().randomCoordinatesWithinBoundsOfView(
    //                of: self.view.frame.maxX,
    //                and: self.view.frame.maxY,
    //                of: Int(buttonSize.width),
    //                and: Int(buttonSize.height))
    //            button.frame = CGRect(x: buttonCoordinate.x,
    //                                  y: buttonCoordinate.y,
    //                                  width: buttonSize.width,
    //                                  height: buttonSize.height)
    //            buttonOverlaps = doesButtonOverlapOnAnyButtonInUI()
    //        }
    //        return buttonCoordinate
    //    }
    //a reusable function to deselect the selected buttons
    private func deselectSelectedButtons(){
        for index in 0..<selectedButtons.count {
            selectedButtons[index].isSelected = false
            selectedButtons[index].layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    private func updateGridAndCardViews(){
        grid = Grid(layout: Grid.Layout.dimensions(rowCount: numberOfRows, columnCount: numberOfCardsPerRow))
        
        grid.frame = CGRect(
            x: viewForAllCards.bounds.minX,
            y: viewForAllCards.bounds.minY,
            width: viewForAllCards.bounds.width,
            height: viewForAllCards.bounds.height)
        for index in 0..<cardViewsOnScreen.count{
            cardViewsOnScreen[index].frame = CGRect(x: (grid[index]?.minX)!, y: (grid[index]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height)
            cardViewsOnScreen[index].setNeedsDisplay()
            cardViewsOnScreen[index].setNeedsLayout()
        }
        
    }
    
    //get the NSAttributed String for the card
    //    private func getNSAttributedString(cardAt index: Int ) -> NSAttributedString {
    //        let card = game.cards[index]
    //        let shapeNSattString = card.shape
    //        let attributesOfNSSattString: [NSAttributedString.Key: Any] = [
    //            .foregroundColor: game.cards[index].shapeColor]
    //        let attributedStringOfCard = NSAttributedString(string: shapeNSattString, attributes: attributesOfNSSattString)
    //        return attributedStringOfCard
    //    }
}
