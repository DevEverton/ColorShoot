//
//  GameScene.swift
//  ColorShoot
//
//  Created by Everton Carneiro on 21/02/2018.
//  Copyright © 2018 Everton. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var colorCircle: SKSpriteNode!
    
    
    let scoreLabel = SKLabelNode(text: "0")
    let levelLabel = SKLabelNode(text: "Level: 1")
    var score = 0
    var level = 1
    
    override func didMove(to view: SKView) {
        layoutScene()
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
        

    }
    
    
    func addLabel(label: SKLabelNode, position: CGPoint, size: CGFloat) {
        label.fontName = "AvenirNext-Bold"
        label.fontSize = size
        label.fontColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        label.position = position
        addChild(label)
    }
    
    
}






