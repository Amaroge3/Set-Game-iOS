//
//  ViewController.swift
//  Set
//
//  Created by Andi Maroge on 11/5/18.
//  Copyright © 2018 Andi Maroge. All rights reserved.
//

import UIKit
class SetViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    
    //: [Outlets] (@next)
    //: Outlet to Deck View in the StoryBoard
    @IBOutlet weak var deck: UIView! {
        didSet { deck.layer.cornerRadius = 10
            deck.layer.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
    }
    //: Outlet to Discard Pile View in the StoryBoard
    @IBOutlet weak var discardPileView: UIView!{
        didSet { discardPileView.layer.cornerRadius = 10
            discardPileView.layer.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    // New Game Button Outlet
    @IBOutlet weak var newGameButton: UIButton!{
        didSet { newGameButton.layer.cornerRadius = 10 }
    }
    // View that holds cards
    @IBOutlet weak var viewForAllCards: UIView!
        { didSet { viewForAllCards.layer.cornerRadius = 10 } }
    
    var grid = Grid(layout: Grid.Layout.dimensions(rowCount: 1, columnCount: 1))
    
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
    
    //:MARK - Dynamic Animator
    lazy var animator = UIDynamicAnimator(referenceView: self.view)
    
    lazy var cardShapes = [Card.Shapes: UIBezierPath]()
    lazy var cardNumberOfShapes = [Card.NumberOfShapes.One : 1,
                                   .Two : 2,
                                   .Three: 3]
    lazy var cardShadings: [Card.Shading: CGFloat] = [Card.Shading.Open: 0,
                                                      .Striped : 0.5,
                                                      .Solid : 1]
    
    override func viewDidLayoutSubviews() {
        //        updateGridForMoreCardsToBeAddedOnScreen()
        //        redrawCardViews()
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        flipCardsAndAnimate(cards: cardViewsOnScreen)
        updateGridForMoreCardsToBeAddedOnScreen()
        redrawCardViews()
    }
    
    /**
     ### Load Card Views
     Loads the card views and adds them to the UI. The card views are stored inside two arrays as references.
     */
    func loadCardViews() {
        
        grid = Grid(layout: Grid.Layout.dimensions(rowCount: numberOfRows, columnCount: numberOfCardsPerRow))
        
        grid.frame = CGRect(
            x: viewForAllCards.bounds.minX,
            y: viewForAllCards.bounds.minY,
            width: viewForAllCards.bounds.width,
            height: viewForAllCards.bounds.height)
        
        for index in 0..<maxCardCount {
            
            let cardFromModel = game.cards[index]
            let cardView = CardView()
            if index < initialCardCount {
                cardView.frame = CGRect(x: (grid[index]?.minX)!, y: (grid[index]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height)
            }
            
            cardView.shape = cardFromModel.shape
            cardView.color = cardFromModel.shapeColor
            cardView.numberOfShapes = cardNumberOfShapes[cardFromModel.numberOfShapes]!
            cardView.shadingAlpha = cardShadings[cardFromModel.shading]!
            cardView.layer.borderWidth = 2
            cardView.layer.cornerRadius = 5
            cardView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cardView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cardView.tag = game.cards[index].identifier
            
            if index < initialCardCount {
                cardViewsOnScreen.append(cardView)
                viewForAllCards.addSubview(cardView)
            }
            else {
                allCardViewsAvailableAndNotOnScreen.append(cardView)
            }
            
            addGestureRecognizerToCardViews(card: cardView)
        }
    }
    /**
     ### Touch Card
     Responds to the touching of the user on the card views in the UI. It changes the UI after the user presses on a card view.
     It then checks to see whether the cards match by interacting with the Model 'Set'.
     
     - Parameters:
        - sender: The gesture recognizer used to detect which view was Tapped.
     */
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
                if selectedCards.count == 3 {
                    var cardsFromModel = [Card]()
                    for index in 0..<selectedCards.count {
                        let nextCard = selectedCards[index]
                        cardsFromModel.append(game.getCardFromModel(with: nextCard.tag))
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
                    if self.numberOfRows >= 1 {
                        self.reduceNumberOfRowsAndReformCardViews()
                        self.redrawCardViews()
                        
                    }
                    self.animateCardViewsWhenMatched(cards: selectedCards)
                    
                    //removes all the cards that are matched from the model to keep the model in
                    //sync with the controller
                    
                    for cardView in selectedCards{
                        game.removeCardFromModel(with: cardView.tag)
                    }
                    
                    self.selectedCards.removeAll()
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
    /**
     ### Set Game Cards
     Sets the game cards in 'Set', which is the model of the game.
     */
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
    
    /**
     ### Add Three More Cards
     
     Adds three more cards to the UI from the 'Deck View' when the user clicks on the 'Deck View'.
     - Parameters:
        - sender: The tap gesture thats used to tap on the 'Deck View'.
 */
    @IBAction func addThreeMoreCardsFromDeck(_ sender: UITapGestureRecognizer) {
        
        animateDeckViewWhenClicked(gesture: sender)
        
        switch sender.state{
        case .ended:
            
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
                newCardsAnimateAndAddToUI(cards: cardsToBeAddedOnScreen)
                
            }
            else {
                if let view = sender.view {
                    view.isUserInteractionEnabled = false
                    view.alpha = 0.10
                    
                }
            }
            //redraw all the subviews on the screen because the frame of the views has changed
            redrawCardViews()
            break
        default: break
        }
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
    
    //redraws the card views that are on the UI
    private func redrawCardViews() {
        for index in 0..<cardViewsOnScreen.count{
            cardViewsOnScreen[index].frame = CGRect(x: (grid[index]?.minX)!, y: (grid[index]?.minY)!, width: grid.cellSize.width, height: grid.cellSize.height)
            cardViewsOnScreen[index].setNeedsDisplay()
            cardViewsOnScreen[index].setNeedsLayout()
        }
    }
    
    //add a gesture recognizer to the UI card views
    private func addGestureRecognizerToCardViews(card: CardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchCard(_:)))
        card.superview?.addGestureRecognizer(tap)
        tap.delegate = self // This is not required
        card.addGestureRecognizer(tap)
    }
    
    //reforms the cards when the user has no more cards available and has more matches. This function decreases
    private func reduceNumberOfRowsAndReformCardViews(){
        
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
    
    func flipCardsAndAnimate(cards: [CardView]){
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: {Timer in
            for cardView in cards {
                UIView.transition(with: cardView, duration: 0.5, options: [.transitionFlipFromLeft],
                                  animations:{ cardView.isFaceUp = !cardView.isFaceUp }, completion: nil)
            }
        })
    }
    //This function animates the deck view when it is clicked when the user wants to add three more cards to the view
    private func animateDeckViewWhenClicked(gesture: UIGestureRecognizer) {
        if let deckView = gesture.view {
            let currentColor = deckView.backgroundColor
            UIView.animate(withDuration: 0.10, animations: { deckView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) },
                           completion: { finished in deckView.backgroundColor = currentColor
            })
        }
    }
    //adds an animation to when the user clicks on the 3 new cards deck. The animation shows 3 new cards coming
    //out of the deck and placed on the screen.
    private func newCardsAnimateAndAddToUI(cards: [CardView]){
        var frameOfCards = [CGRect]()
        deck.layoutIfNeeded()
        for cardView in cards {
            let deckBoundsInsideSuperview = deck.convert(CGPoint(x: deck.bounds.minX, y: deck.bounds.minY), to: viewForAllCards)
            frameOfCards.append(cardView.frame)
            cardView.frame = CGRect(x: deckBoundsInsideSuperview.x, y: deckBoundsInsideSuperview.y,
                                    width: deck!.frame.size.width, height: deck!.frame.size.height)
        }
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0,
            options: [],
            animations: { [unowned self] in
                
                for cardView in cards {
                    cardView.isFaceUp = true
                    self.viewForAllCards.addSubview(cardView)
                }
                for index in 0..<cards.count {
                    cards[index].frame = frameOfCards[index]
                }
                self.redrawCardViews()
                
            },
            completion:nil)
    }
    //this function animates and removes the cards from the view when cards are matched
    private func animateCardViewsWhenMatched(cards: [CardView]){
        
        
        let discardPileBoundsInsideSuperview = self.discardPileView.convert(CGPoint(
            x: self.discardPileView.bounds.minX + discardPileView.frame.size.width * 0.5,
            y: self.discardPileView.bounds.minY + discardPileView.frame.size.height * 0.5),
                                                                            to: self.view)
        
        
        for cardView in cards {
            cardView.frame.size.height = discardPileView.frame.height
            cardView.frame.size.width = discardPileView.frame.width
            cardView.layer.cornerRadius = discardPileView.layer.cornerRadius
            self.viewForAllCards.bringSubviewToFront(cardView)
            
            let animation = CardBehavior(in: animator)
            
            animation.addItem(cardView)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { Timer in
                
                cardView.isFaceUp = false
                animation.addItem(cardView, to: discardPileBoundsInsideSuperview)
            })
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { Timer in
                cardView.removeFromSuperview()
            })
        }
    }
    @IBAction func startNewGame(_ sender: UIButton) {
        game.resetCardsForNewGame()
        self.game = Set(numberOfCards: maxCardCount)
        for card in cardViewsOnScreen {
            card.removeFromSuperview()
        }
        cardViewsOnScreen = [CardView]()
        allCardViewsAvailableAndNotOnScreen = [CardView]()
        
        numberOfRows = 4
        setGameCards()
        //        game.shuffle()
        loadCardViews()
        flipCardsAndAnimate(cards: cardViewsOnScreen)
        
        updateGridForMoreCardsToBeAddedOnScreen()
        redrawCardViews()        
    }

}
extension SetViewController {
    
}
