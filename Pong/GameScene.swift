//
//  GameScene.swift
//  Pong
//
//  Created by Steven Arroyo on 5/16/20.
//  Copyright © 2020 Steven Arroyo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "WorldBrick")
    let player2 = SKSpriteNode(imageNamed: "WorldBrick")
    let ball = SKSpriteNode(imageNamed: "ball")
    var topLabel = SKLabelNode(fontNamed: "Arial")
    var bottomLabel = SKLabelNode(fontNamed: "Arial")
    var score = [0,0]
    
    var sign = Int.random(in: 1..<11) < 6 ? 1 : -1
    var sign2 = Int.random(in: 1..<11) < 6 ? 1 : -1
    
    struct PhysicsCategories {
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1
        static let Ball: UInt32 = 0b10
    }
    
    var gameArea: CGRect
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        var playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        playableWidth += 2 * margin
        gameArea = CGRect(x: 0, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        topLabel.position = CGPoint(x: gameArea.size.width / 2, y: gameArea.size.height / 2 + 80 )
        bottomLabel.position = CGPoint(x: gameArea.size.width / 2, y: gameArea.size.height / 2 - 80)
        topLabel.text = "0"
        bottomLabel.text = "0"
        topLabel.zPosition = 1
        bottomLabel.zPosition = 1
        topLabel.fontSize = 100
        bottomLabel.fontSize = 100
        topLabel.fontColor = SKColor.red
        bottomLabel.fontColor = SKColor.red
        self.addChild(topLabel)
        self.addChild(bottomLabel)
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
        spawnBall()
        
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: player.size.height)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
//        player.physicsBody!.collisionBitMask = 0
        player.physicsBody!.isDynamic = false
        self.addChild(player)
        
        player2.setScale(1)
        player2.position = CGPoint(x: self.size.width/2, y: gameArea.size.height - player2.size.height)
        player2.zPosition = 1
        player2.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player2.physicsBody!.affectedByGravity = false
        //player2.physicsBody!.collisionBitMask = 0
        player2.physicsBody!.isDynamic = false
        self.addChild(player2)
    }
    
    func spawnBall() {

        ball.setScale(0.5)
        ball.position = CGPoint(x: self.size.width/2, y: self.size.height / 2)
        ball.zPosition = 1
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody!.affectedByGravity = false
        ball.physicsBody?.mass = 0.1
        // ball.physicsBody!.collisionBitMask = 0
        ball.physicsBody!.isDynamic = true
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.friction = 0
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.angularDamping = 0
        self.addChild(ball)
        ball.physicsBody?.applyImpulse(CGVector(dx: Int.random(in: 105..<125) * sign, dy: Int.random(in: 105..<125) * sign2))
    }

    override func update(_ currentTime: TimeInterval) {
        sign = Int.random(in: 1..<11) < 6 ? 1 : -1
        sign2 = Int.random(in: 1..<11) < 6 ? 1 : -1
        
        if ball.position.y >=  player2.position.y + player2.size.height / 2 {
            ball.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: Int.random(in: 105..<125) * sign, dy: Int.random(in: 105..<125) * sign2))
                score[1] += 1
                topLabel.text = "\(score[1])"
        } else if ball.position.y <= player.position.y - player.size.height / 2 {
            ball.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.applyImpulse(CGVector(dx: Int.random(in: 105..<125) * sign, dy: Int.random(in: 105..<125) * sign2))
            score[0] += 1
            bottomLabel.text = "\(score[0])"
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if pointOfTouch.y <= gameArea.size.height / 2 {
                player.position.x += amountDragged
                // When using gameArea
                if player.position.x > gameArea.maxX - player.size.width / 2 {
                    player.position.x = gameArea.maxX - player.size.width / 2
                }

                if player.position.x < gameArea.minX + player.size.width / 2 {
                    player.position.x = gameArea.minX + player.size.width / 2
                }
                
            } else {
                player2.position.x += amountDragged
                // When using gameArea
                if player2.position.x > gameArea.maxX - player.size.width / 2 {
                    player2.position.x = gameArea.maxX - player.size.width / 2
                }

                if player2.position.x < gameArea.minX + player.size.width / 2 {
                    player2.position.x = gameArea.minX + player.size.width / 2
                }
            }

            
            
//            if player.position.x > self.size.width - player.size.width / 2 {
//                player.position.x = self.size.width - player.size.width / 2
//            }
//
//            if player.position.x < self.size.width + player.size.width / 2  {
//                player.position.x = self.size.width + player.size.width / 2
//            }
            
            
        }
    }
}
