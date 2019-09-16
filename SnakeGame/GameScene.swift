//
//  GameScene.swift
//  SnakeGame
//
//  Created by Alexey Sobolevsky on 15/09/2019.
//  Copyright © 2019 Alexey Sobolevsky. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var gameFrameRect: CGRect = .zero
    var gameFrameView: SKShapeNode!
    var startButton: SKLabelNode!
    var stopButton: SKLabelNode!
    var snake: Snake?

    override func didMove(to view: SKView) {
        setup(in: view)
    }

    override func update(_ currentTime: TimeInterval) {
        snake?.move()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedNode = findTouchedNode(with: touches) else {
            return
        }

        if let shapeNode = touchedNode as? SKShapeNode,
            touchedNode.name == .counterClockwiseButtonName || touchedNode.name == .clockwiseButtonName {
            shapeNode.fillColor = .green
            if touchedNode.name == .counterClockwiseButtonName {
                snake?.moveCounterClockwise()
            } else if touchedNode.name == .clockwiseButtonName {
                snake?.moveClockwise()
            }
        } else if touchedNode.name == .startButtonName {
            start()
        } else if touchedNode.name == .stopButtonName {
            stop()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedNode = findTouchedNode(with: touches) else {
            return
        }

        if let shapeNode = touchedNode as? SKShapeNode,
            touchedNode.name == .counterClockwiseButtonName || touchedNode.name == .clockwiseButtonName {
            shapeNode.fillColor = .gray
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchedNode = findTouchedNode(with: touches) else {
            return
        }

        if let shapeNode = touchedNode as? SKShapeNode,
            touchedNode.name == .counterClockwiseButtonName || touchedNode.name == .clockwiseButtonName {
            shapeNode.fillColor = .gray
        }
    }

    // MARK: -

    private func start() {
        guard let scene = scene else { return }

        snake = Snake(at: CGPoint(x: scene.frame.midX, y: scene.frame.midY))
        gameFrameView.addChild(snake!)

        createApple()

        startButton.isHidden = true
        stopButton.isHidden = false
    }

    private func stop() {
        snake = nil
        gameFrameView.removeAllChildren()

        startButton.isHidden = false
        stopButton.isHidden = true
    }

    private func setup(in view: SKView) {
        backgroundColor = SKColor.white

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = CollisionCategories.edgeBody
        physicsBody?.collisionBitMask = CollisionCategories.snake | CollisionCategories.snakeHead
        view.showsPhysics = true

        let margin: CGFloat = 20
        let gameFrame = frame.inset(by: view.safeAreaInsets)
        gameFrameRect = CGRect(x: margin, y: margin + view.safeAreaInsets.top + 55,
                               width: gameFrame.width - margin * 2, height: gameFrame.height - margin * 2 - 55)
        drawGameFrame()

        guard let scene = view.scene else {
            return
        }

        let counterClockwiseButton = ControlsFactory.makeButton(at: CGPoint(x: scene.frame.minX + 30, y: scene.frame.minY + 50),
                                                                name: .counterClockwiseButtonName)
        addChild(counterClockwiseButton)

        let clockwiseButton = ControlsFactory.makeButton(at: CGPoint(x: scene.frame.maxX - 90, y: scene.frame.minY + 50),
                                                         name: .clockwiseButtonName)
        addChild(clockwiseButton)

        startButton = SKLabelNode(text: "S T A R T")
        startButton.position = CGPoint(x: scene.frame.midX, y: 55)
        startButton.fontSize = 40
        startButton.fontColor = .green
        startButton.name = .startButtonName
        addChild(startButton)

        stopButton = SKLabelNode(text: "S T O P")
        stopButton.position = CGPoint(x: scene.frame.midX, y: 55)
        stopButton.fontSize = 40
        stopButton.fontColor = .red
        stopButton.name = .stopButtonName
        stopButton.isHidden = true
        addChild(stopButton)
    }

    final func drawGameFrame() {
        gameFrameView = SKShapeNode(rect: gameFrameRect)
        gameFrameView.fillColor = .lightGray
        gameFrameView.lineWidth = 2
        gameFrameView.strokeColor = .green
        addChild(gameFrameView)
    }

    private func findTouchedNode(with touches: Set<UITouch>) -> SKNode? {
        return touches.map { [unowned self] touch in touch.location(in: self) }
            .map { atPoint($0) }
            .first
    }

    private func createApple() {
        let padding: UInt32 = 15
        let randX = CGFloat(arc4random_uniform(UInt32(gameFrameRect.maxX) - padding) + padding)
        let randY = CGFloat(arc4random_uniform(UInt32(gameFrameRect.maxY) - padding) + padding)
        let apple = Apple(at: CGPoint(x: randX, y: randY).relative(to: gameFrameRect))
        gameFrameView.addChild(apple)
    }

}

// MARK: - SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        var contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        contactMask ^= CollisionCategories.snakeHead

        switch contactMask {
        case CollisionCategories.apple:
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            snake?.addBodyPart()
            apple?.removeFromParent()
            createApple()

        case CollisionCategories.edgeBody:
            stop()
            break

        default:
            break
        }
    }

}

private extension String {
    static let counterClockwiseButtonName = "counterClockwiseButton"
    static let clockwiseButtonName = "clockwiseButton"

    static let startButtonName = "startButton"
    static let stopButtonName = "stopButton"
}
