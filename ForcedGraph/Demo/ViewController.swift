//
//  ViewController.swift
//  Force
//
//  Created by Conrad Kramer on 9/3/16.
//  Copyright © 2016 Conrad Kramer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let center: Center<ViewParticle> = Center(.zero)
    private let manyParticle: ManyParticle<ViewParticle> = ManyParticle()
    private let links: Links<ViewParticle> = Links()
    
    var buttonRestart = UIButton(type: UIButtonType.contactAdd)
    
    private lazy var linkLayer: CAShapeLayer = {
        let linkLayer = CAShapeLayer()
        linkLayer.strokeColor = UIColor.gray.cgColor
        linkLayer.fillColor = UIColor.clear.cgColor
        linkLayer.lineWidth = 2
        self.view.layer.insertSublayer(linkLayer, at: 0)
        return linkLayer
    }()
    
    fileprivate lazy var simulation: Simulation<ViewParticle> = {
        let simulation: Simulation<ViewParticle>  = Simulation()
        simulation.insert(force: self.manyParticle)
        simulation.insert(force: self.links)
        simulation.insert(force: self.center)
        simulation.insert(tick: {
            self.linkLayer.path = self.links.path(from: &$0)
        })
        return simulation
    }()
    
    func buildParticles() {
        func particle(color: UIColor,_ symbol: String) -> ViewParticle {
            let view = UIView()
            view.center = CGPoint(x: CGFloat(arc4random_uniform(320)), y: -CGFloat(arc4random_uniform(100)))
            view.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
            let label = UILabel(frame: view.bounds)
            label.text = symbol
            label.textAlignment = .center
            
            self.view.addSubview(view)
            
            let gestureRecogizer = UIPanGestureRecognizer(target: self, action: #selector(dragged(_:)))
            view.addGestureRecognizer(gestureRecogizer)
            
            
            let layer = CAShapeLayer()
            layer.frame = view.bounds
            layer.path = UIBezierPath(ovalIn: CGRect(x: 10, y: 10, width: 30, height: 30)).cgPath
            layer.fillColor = color.cgColor
            layer.strokeColor = UIColor.black.cgColor
            layer.lineWidth = 2
            view.layer.addSublayer(layer)
            view.addSubview(label)
            let particleView = ViewParticle(view: view)
            simulation.insert(particle: particleView)
            return particleView
        }
        
        let c1 = particle(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), "C")
        let h1 = particle(color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), "H")
        let h2 = particle(color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), "H")
        let h3 = particle(color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), "H")
        let c2 = particle(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), "C")
        let h4 = particle(color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), "H")
        let h5 = particle(color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), "H")
        let N1 = particle(color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), "N")
        let O1 = particle(color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), "O")
        let O2 = particle(color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), "O")
        
        let distance: CGFloat = 50
        
        links.link(between: c1, and: h1, distance: distance)
        links.link(between: c1, and: h2, distance: distance)
        links.link(between: c1, and: h3, distance: distance)
        links.link(between: c1, and: c2, distance: distance)
        links.link(between: c2, and: h4, distance: distance)
        links.link(between: c2, and: h5, distance: distance)
        links.link(between: c2, and: N1, distance: distance)
        links.link(between: N1, and: O1, distance: distance)
        links.link(between: N1, and: O2, distance: distance)
        
        
        
        
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        buttonRestart.center = CGPoint(x: view.frame.width/2, y: view.frame.height - 100)
        buttonRestart.tag = 31337
        view.addSubview(buttonRestart)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(restart(_:)))
        buttonRestart.addGestureRecognizer(tap)
        
        buildParticles()
        
    }
    
    func restart(_ sender: Any) {
        simulation.stop()
        view.subviews.forEach {
            if $0.tag != 31337 {
                $0.removeFromSuperview()
            }
        }
        simulation.particles.removeAll()
        links.clear()
        buildParticles()
        simulation.start()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        linkLayer.frame = view.bounds
        center.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        simulation.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        simulation.stop()
    }
    
    @objc private func dragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view, let index = simulation.particles.index(of: ViewParticle(view: view)) else { return }
        var particle = simulation.particles[index]
        switch gestureRecognizer.state {
        case .began:
            particle.fixed = true
        case .changed:
            particle.position = gestureRecognizer.location(in: self.view)
            simulation.kick()
        case .cancelled, .ended:
            particle.fixed = false
            particle.velocity += gestureRecognizer.velocity(in: self.view) * 0.05
        default:
            break
        }
        simulation.particles.update(with: particle)
    }
}
