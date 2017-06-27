//
//  SushiPiece.swift
//  SushiNeko
//
//  Created by timofey makhlay on 6/26/17.
//  Copyright © 2017 timofey makhlay. All rights reserved.
//

import SpriteKit

class SushiPiece: SKSpriteNode {
    
    var rightChopstick: SKSpriteNode!
    var leftChopstick: SKSpriteNode!
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func connectChopsticks() {
        rightChopstick = childNode(withName: "rightChopstick") as! SKSpriteNode
        leftChopstick = childNode(withName: "leftChopstick") as! SKSpriteNode
        
        side = .none
    }
    
    var side: Side = .none {
        
        didSet {
            switch side {
            case .left:
                leftChopstick.isHidden = false
                
            case .right:
                rightChopstick.isHidden = false
                
            case .none:
                leftChopstick.isHidden = true
                rightChopstick.isHidden = true
            }
            
        }
    }
    
    func flip(_ side:Side) {
        
        // MARK: Flipping animation
        
        var actionName: String = ""
        
        if side == .left {
            actionName = "FlipRight"
        } else if side == .right {
            actionName = "FlipLeft"
        }
        
        let flip = SKAction(named: actionName)!
        
        let remove = SKAction.removeFromParent()
        
        let sequence = SKAction.sequence([flip, remove])
        run(sequence)
    }
}
