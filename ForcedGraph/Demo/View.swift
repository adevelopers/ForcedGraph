//
//  Layer.swift
//  ForcedGraph
//
//  Created by Kirill Khudyakov on 07.11.17.
//  Copyright © 2017 Kirill Khudyakov. All rights reserved.
//

import UIKit

public struct ViewParticle: Particle {
    public var velocity: CGPoint
    public var position: CGPoint
    public var fixed: Bool
    public var symbol: String = ""
    
     let view: Unmanaged<UIView>

    public var hashValue: Int {
        return view.takeUnretainedValue().hashValue
    }
    
    public init(view: UIView) {
        self.view = .passUnretained(view)
        self.velocity = .zero
        self.position = view.center
        self.fixed = false
    }
    
    @inline(__always)
    public func tick() {
        view.takeUnretainedValue().center = position
    }
}

public func ==(lhs: ViewParticle, rhs: ViewParticle) -> Bool {
    return lhs.view.toOpaque() == rhs.view.toOpaque()
}
