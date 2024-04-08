//
//  RandomFunction.swift
//  SoFlappyBird
//
//  Created by sose yeritsyan on 01.03.24.
//

import Foundation

public extension CGFloat{
    
    static func random() -> CGFloat {
        return CGFloat(Float.random(in: 0..<1))
    }
    
    static func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return CGFloat.random() * (max - min) + min
    }
    
    
}
