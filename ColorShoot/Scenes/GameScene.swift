//
//  GameScene.swift
//  ColorShoot
//
//  Created by Everton Carneiro on 21/02/2018.
//  Copyright © 2018 Everton. All rights reserved.
//

import SpriteKit

private let red = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
private let yellow = UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0)
private let green = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
private let blue = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)

enum PlayColors {
    //static let colors = [red,yellow,green,blue,]
    static let colors = [green, blue, red, yellow]
}


enum SwitchState: Int {
    
    //case red, yellow, green, blue
    case green, blue, red, yellow
    
}



class GameScene: SKScene {
    
    var colorCircle: SKSpriteNode!
    var ball: SKSpriteNode!
    var switchState = SwitchState.green
    var currentColorIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    let levelLabel = SKLabelNode(text: "Level: 1")
    var score = 0
    var level = 1
    var wheelSpeed = 0.7
    
    override func didMove(to view: SKView) {
        layoutScene()
        turnWheel(speed: wheelSpeed)
        physicsWorld.contactDelegate = self
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
        let changeColor = SKAction.run(changeColorInCircle)
        let sequence = SKAction.sequence([changeColor, rotate])
        colorCircle.run(SKAction.repeatForever(sequence))
   
    }
    
    func changeColorInCircle() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            switchState = newState
            print("Color is:", switchState)
        }else {
            switchState = .green
            print("Color is:", switchState)

        }
        
    }

    func gameOver() {
        print("Errado")
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
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 20.0)
        spawnBall()
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.switchCategory | PhysicsCategories.ballCategory {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                if currentColorIndex == switchState.rawValue {
                    score += 1
                    //run(SKAction.playSoundFileNamed("bling", waitForCompletion: false))
                    print("Certo")
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion: {
                        ball.removeFromParent()
                    })
                }else {
                    gameOver()
                }
            }
        }

    }
    
    
}





