//
//  GameScene.swift
//  ColorShoot
//
//  Created by Everton Carneiro on 21/02/2018.
//  Copyright © 2018 Everton. All rights reserved.
//

import SpriteKit

enum PlayColors {
    
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0),
        
        ]
}

enum SwitchState: Int {
    
    case red, yellow, green, blue
    
}

class GameScene: SKScene {
    
    var colorCircle: SKSpriteNode!
    var ball: SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    let levelLabel = SKLabelNode(text: "Level: 1")
    var score = 0
    var level = 1
    var wheelSpeed = 0.7
    
    override func didMove(to view: SKView) {
        layoutScene()
        turnWheel(speed: wheelSpeed)
    }
    
    func layoutScene() {
        backgroundColor = .white
        colorCircle = SKSpriteNode(imageNamed: "ColorCircle")
        colorCircle.size = CGSize(width: frame.size.width, height: frame.size.width)
        colorCircle.position = CGPoint(x: frame.size.width/2, y: frame.maxY)
        colorCircle.physicsBody = SKPhysicsBody(circleOfRadius: colorCircle.size.width/2)
        colorCircle.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorCircle.physicsBody?.isDynamic = false
        addChild(colorCircle)
        
        addLabel(label: levelLabel, position: CGPoint(x: frame.minX + 10, y: frame.minY + 10), size: 20.0)
        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        addLabel(label: scoreLabel, position: CGPoint(x: frame.midX, y: frame.maxY - 10), size: 50.0 )
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        spawnBall()

    }
    
    
    func addLabel(label: SKLabelNode, position: CGPoint, size: CGFloat) {
        label.fontName = "AvenirNext-Bold"
        label.fontSize = size
        label.fontColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        label.position = position
        addChild(label)
    }
    
    func turnWheel(speed: TimeInterval) {
        let rotate = SKAction.rotate(byAngle: .pi/2, duration: speed)
        colorCircle.run(SKAction.repeatForever(rotate))
    }
    
    func spawnBall() {
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 40.0, height: 40.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.minY + 20)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        ball.physicsBody?.isDynamic = false
        addChild(ball)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ball.physicsBody?.isDynamic = true
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 9.0)
        spawnBall()
    }
    
    
}






