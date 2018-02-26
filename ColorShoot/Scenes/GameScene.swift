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
    static let colors = [green, blue, red, yellow]
}


enum SwitchState: Int {
    
    case green, blue, red, yellow
    
}

class GameScene: SKScene {
    
    var colorCircle: SKSpriteNode!
    var ball: SKSpriteNode!
    var switchState = SwitchState.green
    var currentColorIndex: Int?
    var timer = Timer()
    var counter = 3
    
    let scoreLabel = SKLabelNode(text: "0")
    let timerLabel = SKLabelNode(text: "3")
    var ballSpeed = 30.0
    var score = 0
    var wheelSpeed = 0.5

    
    override func didMove(to view: SKView) {
        layoutScene()
        turnWheel(speed: wheelSpeed)
        createTimer()
        
        physicsWorld.contactDelegate = self
        
        let swipeUp : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipedUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
    }
    
    @objc func swipedUp() {
        ball.physicsBody?.isDynamic = true
        physicsWorld.gravity = CGVector(dx: 0.0, dy: ballSpeed)
    }
    
    func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.updateTimer), userInfo: nil, repeats: true)
        animateLabel(timerLabel)
    }
    
    
    @objc func updateTimer() {
        counter -= 1
        timerLabel.text = "\(counter)"
        if counter == 0 {
            gameOver()
        }
    }
    
    func layoutScene() {
        backgroundColor = .white
        colorCircle = SKSpriteNode(imageNamed: "ColorCircle")
        colorCircle.size = CGSize(width: frame.size.width, height: frame.size.width)
        colorCircle.position = CGPoint(x: frame.size.width/2, y: frame.maxY)
        colorCircle.physicsBody = SKPhysicsBody(circleOfRadius: colorCircle.size.width/2)
        colorCircle.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorCircle.physicsBody?.isDynamic = false
        colorCircle.zPosition = 0
        addChild(colorCircle)
        
//        addLabel(label: levelLabel, position: CGPoint(x: frame.minX + 10, y: frame.minY + 10), size: 20.0)
//        levelLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        addLabel(label: scoreLabel, position: CGPoint(x: frame.midX, y: frame.maxY - 10), size: 50.0 )
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        scoreLabel.zPosition = 1
        addLabel(label: timerLabel, position: CGPoint(x: frame.midX, y: frame.midY), size: 40)
        spawnBall()

    }
    

    
    func turnWheel(speed: TimeInterval) {
        let rotate = SKAction.rotate(byAngle: .pi/2, duration: speed)
        let changeColor = SKAction.run(changeColorInCircle)
        let delay = SKAction.wait(forDuration: speed)
        let sequence = SKAction.sequence([delay, changeColor])

        colorCircle.run(SKAction.repeatForever(sequence))
        colorCircle.run(SKAction.repeatForever(rotate))
  
    }
    
    func increaseSpeed(to speed: Double, ballGravity: Double) {
        wheelSpeed = speed
        ballSpeed = ballGravity
    }
    

    func changeColorInCircle() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            switchState = newState
        }else {
            switchState = .green
        }
    }

    func gameOver() {
        timer.invalidate()
        UserDefaults.standard.set(score, forKey: "Score")
        
        if score > UserDefaults.standard.integer(forKey: "NewRecord") {
            UserDefaults.standard.set(score, forKey: "NewRecord")
        }
        
        NotificationCenter.default.post(name: Notification.Name("showIntersticialAd"), object: self)
        
        let gameOverScene = GameOverScene(size: view!.bounds.size)
        view!.presentScene(gameOverScene)
    }
    
    func spawnBall() {
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 50.0, height: 50.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        ball.physicsBody?.isDynamic = false
        addChild(ball)
        counter = 4
        
  
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.switchCategory | PhysicsCategories.ballCategory {
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode {
                if currentColorIndex == switchState.rawValue {
                    run(SKAction.playSoundFileNamed("bling", waitForCompletion: false))
                    score += 1
                    scoreLabel.text = "\(score)"
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion: {
                        ball.removeFromParent()
                        self.spawnBall()
                    })
                }else {
                    gameOver()
                    
                }
            }
        }

    }
   
}

extension SKScene {
    
    func addLabel(label: SKLabelNode, position: CGPoint, size: CGFloat) {
        label.fontName = "AvenirNext-Bold"
        label.fontSize = size
        label.fontColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        label.position = position
        addChild(label)
    }
    
    func animateLabel(_ label: SKLabelNode) {
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp,scaleDown])
        label.run(SKAction.repeatForever(sequence))
    }
    
}




