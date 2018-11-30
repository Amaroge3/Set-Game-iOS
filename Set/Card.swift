//
//  Card.swift
//  Set
//
//  Created by Andi Maroge on 11/6/18.
//  Copyright © 2018 Andi Maroge. All rights reserved.
//

import Foundation
import UIKit
struct Card {
    
    var identifier = 0
    var shape = ""
    var numberOfShapes = 0
    var shading = ""
    var shapeColor = UIColor()
    var isSelected = false
    
    
    static var identifierFactory = 0
    
    enum Shapes: String {
        case Squiggle = "■"
        case Diamond = "▲"
        case Oval = "●"
        
        static var all = [Shapes.Squiggle, .Diamond, .Oval]
    }
    enum Number: Int {
        case One = 1
        case Two = 2
        case Three = 3
        
        static var all = [Number.One, .Two, .Three]
    }
    enum Color {
        case Red
        case Green
        case Purple
        
        static var all = [Color.Red, .Green, .Purple]
    }
    
    enum Shading: String {
        case Solid = "Solid"
        case Striped = "Striped"
        case Open = "Open"
        
        static var all = [Shading.Solid, .Striped, .Open]
    }
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init(){
        self.identifier = Card.getUniqueIdentifier()
    }
}
extension Card.Color: RawRepresentable {
    typealias RawValue = UIColor
    
    init?(rawValue: UIColor) {
        switch rawValue {
        case UIColor.red: self = .Red
        case UIColor.purple: self = .Purple
        case UIColor.green: self = .Green
        default: return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .Red: return UIColor.red
        case .Purple: return UIColor.purple
        case .Green: return UIColor.green
        }
    }
}
