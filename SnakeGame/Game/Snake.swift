//
//  Snake.swift
//  SnakeGame
//
//  Created by Alexey Sobolevsky on 16/09/2019.
//  Copyright © 2019 Alexey Sobolevsky. All rights reserved.
//

import SpriteKit

class Snake: SKShapeNode {
    var moveSpeed: CGFloat = 125
    var angle: CGFloat = 0

    var body = [SnakeBodyPart]()

    convenience init(at point: CGPoint) {
        self.init()

        let head = SnakeHead(at: point)
        body.append(head)
        addChild(head)
    }

    func addBodyPart() {
        let newBodyPart = SnakeBodyPart(at: body[0].position)
        body.append(newBodyPart)
        addChild(newBodyPart)
    }

    func move() {
        guard body.isEmpty == false else { return }

        let head = body[0]
        moveHead(head)

        for index in 0..<body.count where index > 0 {
            let previousBodyPart = body[index - 1]
            let currentBodyPart = body[index]
            moveBodyPart(previousBodyPart, c: currentBodyPart)
        }
    }

    func moveClockwise() {
        angle += CGFloat(Double.pi / 2)
    }

    func moveCounterClockwise() {
        angle -= CGFloat(Double.pi / 2)
    }

    private func moveHead(_ head: SKShapeNode) {
        let dx = moveSpeed * sin(angle)
        let dy = moveSpeed * cos(angle)
        let nextPosition = CGPoint(x: head.position.x + dx, y: head.position.y + dy)
        let moveAction = SKAction.move(to: nextPosition, duration: 1.0)
        head.run(moveAction)
    }

    private func moveBodyPart(_ p: SnakeBodyPart, c: SnakeBodyPart) {
        let moveAction = SKAction.move(to: CGPoint(x: p.position.x, y: p.position.y), duration: 0.1)
        c.run(moveAction)
    }
}
