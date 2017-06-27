//
//  GameScene.swift
//  SushiNeko
//
//  Created by timofey makhlay on 6/26/17.
//  Copyright © 2017 timofey makhlay. All rights reserved.
//

import SpriteKit

enum Side {
    case left, right, none
}

enum GameState {
    case title, ready, playing, gameOver
}

class GameScene: SKScene {
    
    var playButton: MSButtonNode!
    
    var state: GameState = .title
    
    var sushiTower: [SushiPiece] = []
    
    var character: Character!
    
    var sushiBasePiece: SushiPiece!
    
    var healthBar: SKSpriteNode!
    
    var health: CGFloat = 1.0 {
        didSet {
            // Bar health between 0.0 -> 1.0
            healthBar.xScale = health
        }
    }
    
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        character = childNode(withName: "character") as! Character
        playButton = childNode(withName: "playButton") as! MSButtonNode
        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        
        
        sushiBasePiece.connectChopsticks()
        
        // MARK: manually stack the first two pieces
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        addRandomPieces(total: 10)
        
        // MARK: PlayButton
        playButton.selectedHandler = {
            // Start game
            self.state = .ready
        }
    }
    
    func addTowerPiece (side: Side) {
        
        // MARK: adding new pieces to tower.
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        
        let lastPiece = sushiTower.last
        
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position.x = lastPosition.x
        newPiece.position.y = lastPosition.y + 72
        
        // Increments of Z position
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition
        
        newPiece.side = side
        addChild(newPiece)
        sushiTower.append(newPiece)
    }
    
    func addRandomPieces ( total: Int)
    {
        // MARK: add random pieces
        for _ in 1...total {
            
            let lastPiece = sushiTower.last!
            
            if lastPiece.side != .none {
                addTowerPiece(side: .none)
            } else {
                let rand = arc4random_uniform(100)
                
                if rand < 45 {
                    addTowerPiece(side: .left)
                } else if rand < 90 {
                    addTowerPiece(side: .right)
                } else {
                    addTowerPiece(side: .none)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // MARK: Disable touch
        if state == .gameOver || state == .title { return }
        
        if state == .ready {
            state = .playing
        }
        
        let touch = touches.first!
        
        let location = touch.location(in: self )
        
        if location.x > size.width / 2 {
            character.side = .right
        } else {
            character.side = .left
        }
        
        if let firstPiece = sushiTower.first {
            sushiTower.removeFirst()
            
            if character.side == firstPiece.side {
                gameOver()
                
                return
            }
            
            // MARK: Animate the punch
            firstPiece.flip( character.side)
            
            addRandomPieces(total: 1)
        }
        
        // MARK: Add score and Add Health
        health += 0.1
        score += 1
        
        /* Cap Health */
        if health > 1.0 {health = 1.0}
    }
    
    func moveTowerDown() {
        var n: CGFloat = 0
        for piece in sushiTower {
            let y = (n * 72) + 232
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
    }
    override func update(_ currentTime: TimeInterval) {
        moveTowerDown()
        
        // MARK: Decrease Health
        if state != .playing {
            return
        }
        
        health -= 0.01
        
        if health < 0 {
            gameOver()
        }
    }
    
    func gameOver() {
        // MARK: Game Over Function
        state = .gameOver
        
        // MARK: Colorize pieces
        for SushiPiece in sushiTower {
            
            SushiPiece.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        }
        
        character.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        
        sushiBasePiece.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        
        playButton.selectedHandler = {
            let skView = self.view as SKView!
            
            guard let scene =  GameScene(fileNamed: "GameScene") as GameScene! else {
                return
            }
            
            scene.scaleMode = .aspectFill
            
            skView?.presentScene(scene)
        }
        
    }
}
