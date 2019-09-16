//
//  CGPoint+Extensions.swift
//  SnakeGame
//
//  Created by Alexey Sobolevsky on 16/09/2019.
//  Copyright © 2019 Alexey Sobolevsky. All rights reserved.
//

import UIKit

extension CGPoint {

    func relative(to frame: CGRect) -> CGPoint {
        return CGPoint(x: frame.origin.x + x, y: frame.origin.y + y)
    }
}
