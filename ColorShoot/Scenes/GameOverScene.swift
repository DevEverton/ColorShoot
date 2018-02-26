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
    let backToMenuLabel = SKLabelNode(text: "Back to Menu")
    let scoreLabel = SKLabelNode(text: "Score: \(UserDefaults.standard.integer(forKey: "Score"))")
    let newRecordLabel = SKLabelNode(text: "New Record: \(UserDefaults.standard.integer(forKey: "NewRecord"))")
    let score = UserDefaults.standard.integer(forKey: "Score")
    let newRecord = UserDefaults.standard.integer(forKey: "NewRecord")

    override func didMove(to view: SKView) {
        layoutScene()
        
    }
    
    func layoutScene() {
        backgroundColor = .white
        addLabel(label: gameOverLabel, position: CGPoint(x: frame.midX, y: frame.midY), size: 35.0)
        addLabel(label: backToMenuLabel, position: CGPoint(x: frame.midX, y: frame.midY - 70.0), size: 25.0)

        

        if newRecord > score {
            addLabel(label: scoreLabel, position: CGPoint(x: frame.midX, y: frame.midY + 70.0), size: 25.0 )
            scoreLabel.run(SKAction.scale(to: 1.2, duration: 0.5), completion: {
                self.gameOverLabel.run(SKAction.scale(to: 1.4, duration: 0.5), completion: {
                    self.backToMenuLabel.run(SKAction.scale(to: 1.2, duration: 0.5))
                    self.animateLabel(self.backToMenuLabel)
                })
            })
        }else {
            addLabel(label: newRecordLabel, position: CGPoint(x: frame.midX, y: frame.midY + 70.0), size: 25.0)
            newRecordLabel.run(SKAction.scale(to: 1.2, duration: 0.5), completion: {
                self.gameOverLabel.run(SKAction.scale(to: 1.4, duration: 0.5), completion: {
                    self.backToMenuLabel.run(SKAction.scale(to: 1.2, duration: 0.5))
                    self.animateLabel(self.backToMenuLabel)
                })
            })
            
        }


        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let menuScene = MenuScene(size: view!.bounds.size)
        view!.presentScene(menuScene)
    }
    
    
    
}
