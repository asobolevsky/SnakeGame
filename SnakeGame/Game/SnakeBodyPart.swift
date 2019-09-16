//
//  SnakeBodyPart.swift
//  SnakeGame
//
//  Created by Alexey Sobolevsky on 16/09/2019.
//  Copyright © 2019 Alexey Sobolevsky. All rights reserved.
//

import SpriteKit

class SnakeBodyPart: SKShapeNode {

    init(at point: CGPoint, diameter: CGFloat = 10.0) {
        super.init()
        path = UIBezierPath(ovalIn: CGRect(x: -diameter/2, y: -diameter/2, width: diameter, height: diameter)).cgPath
        fillColor = .green
        strokeColor = UIColor.green.withAlphaComponent(0.7)
        lineWidth = 5
        position = point

        physicsBody = SKPhysicsBody(circleOfRadius: diameter - 4, center: .zero)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = CollisionCategories.snake
        physicsBody?.contactTestBitMask = CollisionCategories.edgeBody | CollisionCategories.apple
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
