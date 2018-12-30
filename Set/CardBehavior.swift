//
//  CardBehavior.swift
//  Set
//
//  Created by Andi Maroge on 12/30/18.
//  Copyright © 2018 Andi Maroge. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior:UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.5
        behavior.resistance = 0.5
        return behavior
    }()

private func push(_ item: UIDynamicItem){
    let push =  UIPushBehavior(items: [item], mode: .instantaneous)
    push.angle = (2*CGFloat.pi).arc4random
    push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
    push.action = { [unowned push, weak self] in
        self?.removeChildBehavior(push)
    }
        addChildBehavior(push)
    }
    private func snap(item: UIDynamicItem, to point: CGPoint){
        let snapBehavior = UISnapBehavior(item: item, snapTo: CGPoint(x: point.x, y: point.y))
        snapBehavior.damping = 2
            
            snapBehavior.action = {
                self.collisionBehavior.removeItem(item)
                self.itemBehavior.removeItem(item)
            }
        addChildBehavior(snapBehavior)
    }
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func addItem(_ item: UIDynamicItem, to point: CGPoint){
        snap(item: item, to: point)
    }
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator){
        self.init()
        animator.addBehavior(self)
    }
}
