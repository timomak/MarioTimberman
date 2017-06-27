//
//  Character.swift
//  SushiNeko
//
//  Created by timofey makhlay on 6/27/17.
//  Copyright © 2017 timofey makhlay. All rights reserved.
//

import SpriteKit

class Character: SKSpriteNode {
    
    // MARK: Character Side
    var side: Side = .left {
        didSet {
            if side == .left {
                xScale = 1
                position.x = 91
            } else {
                // Flip
                xScale = -1
                position.x = 229
            }
            let punch = SKAction(named: "Punch")!
            run(punch)
        }
    }
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
