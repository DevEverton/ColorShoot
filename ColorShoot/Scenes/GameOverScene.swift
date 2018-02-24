//
//  GameOverScene.swift
//  ColorShoot
//
//  Created by Everton Carneiro on 24/02/2018.
//  Copyright © 2018 Everton. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    let gameOverLabel = SKLabelNode(text: "Game Over")
    let playAgainLabel = SKLabelNode(text: "Tap to play Again")

    override func didMove(to view: SKView) {
        layoutScene()
    }
    
    func layoutScene() {
        backgroundColor = .white
        addLabel(label: gameOverLabel, position: CGPoint(x: frame.midX, y: frame.midY), size: 40.0)
        addLabel(label: playAgainLabel, position: CGPoint(x: frame.midX, y: frame.midY - 70.0), size: 30.0)
        animateLabel(gameOverLabel)
        animateLabel(playAgainLabel)
    }
    
    
    
}
