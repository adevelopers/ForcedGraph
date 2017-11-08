//
//  Links.swift
//  ForcedGraph
//
//  Created by Kirill Khudyakov on 07.11.17.
//  Copyright © 2017 Kirill Khudyakov. All rights reserved.
//

import CoreGraphics

public final class Links<T: Particle>: Force {
    
    var distance: CGFloat = 40
        
    private var links: Set<Link<T>> = []
    private var degrees: Dictionary<T, UInt> = [:]
    
    public init() {
        
    }
    
    public func link(between a: T, and b: T, strength: CGFloat? = nil, distance: CGFloat? = nil) {
        if links.update(with: Link(between: a, and: b, strength: strength, distance: distance)) == nil {
            degrees[a] = (degrees[a] ?? 0) + 1
            degrees[b] = (degrees[b] ?? 0) + 1
        }
    }

    public func unlink(between a: T, and b: T) {
        if links.remove(Link(between: a, and: b, strength: nil, distance: distance)) != nil {
            degrees[a] = (degrees[a] ?? 0) - 1
            degrees[b] = (degrees[b] ?? 0) - 1
        }
    }

    public func tick(alpha: CGFloat, particles: inout Set<T>) {
        for link in links {            
            link.tick(alpha: alpha, degrees: degrees, distance: distance, particles: &particles)
        }
    }
    
    public func path(from particles: inout Set<T>) -> CGPath {
        let path = CGMutablePath()
        for link in links {
            guard let fromIndex = particles.index(of: link.a),
                let toIndex = particles.index(of: link.b) else { continue }
            path.move(to: particles[fromIndex].position)
            path.addLine(to: particles[toIndex].position)
        }
        return path
    }
    
    public func clear() {
        self.links.removeAll()
    }
}
