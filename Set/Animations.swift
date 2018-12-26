//
//  Animations.swift
//  Set
//
//  Created by Andi Maroge on 12/21/18.
//  Copyright © 2018 Andi Maroge. All rights reserved.
//

import Foundation
import UIKit


final class Animations {

func flipCardsAndAnimate(cards: [CardView]){
    
    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: {Timer in
        for cardView in cards {
            //            cardView.isFaceUp = true
            
            UIView.transition(with: cardView, duration: 0.5,
                              options: [.transitionFlipFromLeft],
                              animations:{ cardView.isFaceUp = !cardView.isFaceUp },
                              completion: nil)
        }
    })
}

    func animateWhenCardsMatch(controller: ViewController, cards: [CardView]){
        
    }
}
