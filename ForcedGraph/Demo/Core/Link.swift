//
//  Link.swift
//  ForcedGraph
//
//  Created by Kirill Khudyakov on 07.11.17.
//  Copyright © 2017 Kirill Khudyakov. All rights reserved.
//

import CoreGraphics


func ==<T: Particle>(lhs: Link<T>, rhs: Link<T>) -> Bool {
    return ((lhs.a == rhs.a && lhs.b == rhs.b) || (lhs.a == rhs.b && lhs.b == rhs.a))
}

struct Link<T: Particle>: Hashable {
    let a: T
    let b: T
    let strength: CGFloat?
    let distance: CGFloat?
    
    var hashValue: Int {
        return a.hashValue ^ b.hashValue
    }
    
    init(between a: T, and b: T, strength: CGFloat? = nil, distance: CGFloat? = nil) {
        self.a = a
        self.b = b
        self.strength = strength
        self.distance = distance
    }
    
    public func tick(alpha: CGFloat, degrees: Dictionary<T, UInt>, distance: CGFloat, particles: inout Set<T>) {
        guard let fromIndex = particles.index(of: a),
            let toIndex = particles.index(of: b) else { return }
        
        var from = particles[fromIndex]
        var to = particles[toIndex]
        
        let fromDegree = CGFloat(degrees[a] ?? 0)
        let toDegree = CGFloat(degrees[b] ?? 0)
        
        let bias = fromDegree / (fromDegree + toDegree)
        let distance = (self.distance ?? distance)
        let strength = (self.strength ?? 0.7 / CGFloat(min(fromDegree, toDegree)))
        
        let delta = (to.position + to.velocity - from.position - from.velocity).jiggled
        let magnitude = delta.magnitude
        let value = delta * ((magnitude - distance) / magnitude) * alpha * strength
        
        to.velocity -= value * bias;
        from.velocity += (value * (1 - bias))
        
        particles.update(with: from)
        particles.update(with: to)
    }
}
