//
//  ViewController.swift
//  Set
//
//  Created by Andi Maroge on 11/5/18.
//  Copyright © 2018 Andi Maroge. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
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
    //initial number of buttons in the UI
    var initialCardCount = 12
    //maximum number of cards in the game
    var maxCardCount = 81
    //card views not on screen
    var allCardViewsAvailableAndNotOnScreen = [CardView]()
    //card views on screen
    var cardViewsOnScreen = [CardView]()
    //selected buttons array
    lazy var selectedCards = [CardView]()
    var numberOfRows = 4
    let numberOfCardsPerRow = 3
    
    
    lazy var animation = Animations()

    override func viewDidLayoutSubviews() {
        updateGridForMoreCardsToBeAddedOnScreen()
        redrawCardViews()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGameCards()
//        game.shuffle()
        loadCardViews()

        
        for index in 0..<game.cards.count {
            let card = game.cards[index]
            print("index: \(index) shape:\(card.shape) number: \(card.numberOfShapes) id: \(card.identifier) shapeColor: \(card.shapeColor) shading: \(card.shading)")
        }
        print(game.cards.count)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        animation.flipCardsAndAnimate(cards: cardViewsOnScreen)
    }
    
    
    func loadCardViews() {
        
        grid = Grid(layout: Grid.Layout.dimensions(rowCount: numberOfRows, columnCount: numberOfCardsPerRow))
        
        grid.frame = CGRect(
            x: viewForAllCards.bounds.minX,
            y: viewForAllCards.bounds.minY,
            width: viewForAllCards.bounds.width,
            height: viewForAllCards.bounds.height)
        
        for index in 0..<maxCardCount {
            
            
            let cardFromModel = game.cards[index]
            let card = CardView()
            if index < initialCardCount {
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
            card.tag = game.cards[index].identifier
            
            if index < initialCardCount {
                cardViewsOnScreen.append(card)
                viewForAllCards.addSubview(card)
                
            }
            else {
                allCardViewsAvailableAndNotOnScreen.append(card)
            }
            
           addGestureRecognizerToCardViews(card: card)
            
        }
        
   
        
    }
    //when the user touches a card on the UI
    @objc func touchCard(_ sender: UITapGestureRecognizer) {
        
        var cardsMatch = false
        
        let yourTag = sender.view!.tag // this is the tag of your gesture's object
        // do whatever you want from here :) e.g. if you have an array of buttons instead of just 1:
        for card in cardViewsOnScreen {
            if(card.tag == yourTag) {
                //select and deselect button
                if selectedCards.count < 3 {
                    //if the button is not selected, select the button
                    if card.isSelected == false {
                        card.isSelected = true
                        card.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                        selectedCards.append(card)
                    }
                        //if the button is selected, deselect the button
                    else {
                        card.isSelected = false
                        card.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        selectedCards.removeLast()
                    }
                }
                //when the number of buttons in the array is equal to 3, check if cards match
                if selectedCards.count == 3{
                    var cardsFromModel = [Card]()
                    for index in 0..<selectedCards.count {
                        let nextCard = selectedCards[index]
                        cardsFromModel.append(game.cards[nextCard.tag - 1])
                    }
                    cardsMatch = game.isSelectionASet(cardsSelected: cardsFromModel)
                }
                //if cards do match, then remove the cards from view
                if cardsMatch {
                    deselectSelectedButtons()
                    for index in 0..<selectedCards.count {
                        let nextCard = selectedCards[index]
                        
                        //remove the cards that are selected from the array that holds the cards that are on screen
                        let filterArray = cardViewsOnScreen.filter { !$0.contains(nextCard) }
                        cardViewsOnScreen = filterArray
                    }
                    
                    UIViewPropertyAnimator.runningPropertyAnimator(
                        withDuration: 0.5,
                        delay: 0,
                        options: [],
                        animations: {

                            self.selectedCards.forEach{
//                                $0.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
                                $0.frame = CGRect(x: self.viewForAllCards.bounds.midX - $0.frame.width * 0.5, y: self.viewForAllCards.bounds.maxY,
                                                  width: $0.frame.width, height: $0.frame.height  )
                            }
                    },
                        completion: {position in
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.5,
                                delay: 0,
                                options: [],
                                animations: {
                                    self.selectedCards.forEach{
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                        $0.alpha = 0
                                    }
                            },
                                completion: { finished in
                                    self.selectedCards.forEach{
                                        $0.removeFromSuperview()
                                    }
                                    self.selectedCards.removeAll()
                                    if self.numberOfRows >= 1 {
                                        self.reformCards()
                                        self.redrawCardViews()
                                    }
                                    
                            })
                            
                            
                            
                    })
                }
                //when 3 buttons are not matched and the user selects another button not selected previously, deselect and remove all buttons
                //previously selected, and select the new unselected button
                if !card.isSelected, selectedCards.count == 3, !cardsMatch{
                    deselectSelectedButtons()
                    selectedCards.removeAll()
                    selectedCards.append(card)
                    card.isSelected = true
                    card.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                }
            }
        }
    }
    //set the game cards
    private func setGameCards(){
        
        var tempShapeColor = Card.Color.all, tempShape = Card.Shapes.all, tempNumberOfShapes = Card.NumberOfShapes.all, tempShading = Card.Shading.all
        var colorCounter = 0, shapeCounter = 0 , numberOfShapesCounter = 0, shadingCounter = 0
        
        for index in 0..<maxCardCount {
            
            if  (index > 1 && index % 9 == 0){
                shapeCounter += 1
            }
            if  (index > 1 && index % 27 == 0){
                shadingCounter += 1
            }
            if index > 1, index % 3 == 0 {
                colorCounter += 1
            }
            if numberOfShapesCounter == tempNumberOfShapes.count { numberOfShapesCounter = 0 }
            if colorCounter == tempShapeColor.count { colorCounter = 0}
            if shapeCounter == tempShape.count { shapeCounter = 0 }
            if shadingCounter == tempShading.count { shadingCounter = 0 }
            
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
        if allCardViewsAvailableAndNotOnScreen.count >= 3 {
            //increase the number of rows for the grid
            numberOfRows += 1
            //update the grid to add more cards to the screen
            updateGridForMoreCardsToBeAddedOnScreen()
            
            var cardsToBeAddedOnScreen = [CardView]()
            //grab three cards and add them to screen
            for _ in 1...3 {
                let currentCardCount = cardViewsOnScreen.count
                                //remove card from the array that contains cards not on screen yet
                let card = allCardViewsAvailableAndNotOnScreen.removeFirst()

                card.frame = CGRect(x: (grid[currentCardCount]?.minX)!, y: (grid[currentCardCount]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height)
                cardsToBeAddedOnScreen.append(card)
                
                cardViewsOnScreen.append(card)
            }
            animation.flipCardsAndAnimate(cards: cardsToBeAddedOnScreen)
            for card in cardsToBeAddedOnScreen {
            viewForAllCards.addSubview(card)
            }

        }
        else {
            sender.isEnabled = false
            sender.alpha = 0.10
        }
        //redraw all the subviews on the screen because the frame of the views has changed
        redrawCardViews()
    }
    
    //a reusable function to deselect the selected buttons
    private func deselectSelectedButtons(){
        for index in 0..<selectedCards.count {
            selectedCards[index].isSelected = false
            selectedCards[index].layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    private func updateGridForMoreCardsToBeAddedOnScreen(){
        grid = Grid(layout: Grid.Layout.dimensions(rowCount: numberOfRows, columnCount: numberOfCardsPerRow))
        
        grid.frame = CGRect(
            x: viewForAllCards.bounds.minX,
            y: viewForAllCards.bounds.minY,
            width: viewForAllCards.bounds.width,
            height: viewForAllCards.bounds.height)
    }
    
    private func redrawCardViews() {
        for index in 0..<cardViewsOnScreen.count{
            cardViewsOnScreen[index].frame = CGRect(x: (grid[index]?.minX)!, y: (grid[index]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height)
            cardViewsOnScreen[index].setNeedsDisplay()
            cardViewsOnScreen[index].setNeedsLayout()
        }
    }
    
    private func addGestureRecognizerToCardViews(card: CardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchCard(_:)))
        card.superview?.addGestureRecognizer(tap)
        tap.delegate = self // This is not required
        card.addGestureRecognizer(tap)
    }
    
    private func reformCards(){
        
        numberOfRows -= 1
        if numberOfRows != 0 {
            grid = Grid(layout: Grid.Layout.dimensions(rowCount: numberOfRows, columnCount: numberOfCardsPerRow))
        }
        grid.frame = CGRect(
            x: viewForAllCards.bounds.minX,
            y: viewForAllCards.bounds.minY,
            width: viewForAllCards.bounds.width,
            height: viewForAllCards.bounds.height)
    }
}
