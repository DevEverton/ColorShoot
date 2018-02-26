//
//  MenuScene.swift
//  ColorShoot
//
//  Created by Everton Carneiro on 25/02/2018.
//  Copyright © 2018 Everton. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    let gameName = SKLabelNode(text: "Color Shoot")
    let lastScore = SKLabelNode(text: "Last: \(UserDefaults.standard.integer(forKey: "Score"))")
    let record = SKLabelNode(text: "Record: \(UserDefaults.standard.integer(forKey: "NewRecord"))")
    let play = SKLabelNode(text: "Tap to play")
    var colorCircle: SKSpriteNode!

    override func didMove(to view: SKView) {
        layoutScene()
    }
    
    func layoutScene() {
        backgroundColor = .white
        colorCircle = SKSpriteNode(imageNamed: "ColorCircle")
        colorCircle.size = CGSize(width: frame.size.width - 50, height: frame.size.width - 50)
        colorCircle.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        colorCircle.zPosition = 0
        addChild(colorCircle)
        let rotate = SKAction.rotate(byAngle: .pi/2, duration: 1.0)
        colorCircle.run(SKAction.repeatForever(rotate))
        
        addLabel(label: gameName, position: CGPoint(x: frame.midX, y: frame.midY + 50), size: 32.0)
        gameName.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        gameName.fontName = "AvenirNext-Heavy"
        gameName.zPosition = 1
        addLabel(label: lastScore, position: CGPoint(x: frame.minX, y: frame.maxY - 20), size: 22.0)
        lastScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        addLabel(label: record, position: CGPoint(x: frame.maxX, y: frame.maxY - 20), size: 22.0)
        record.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        addLabel(label: play, position: CGPoint(x: frame.midX, y: frame.midY - 200), size: 25.0)
        animateLabel(play)

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
    
    
}
