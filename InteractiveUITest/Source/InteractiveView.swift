//
//  InteractiveView.swift
//  InteractiveUITest
//
//  Created by fahid.attique on 26/12/2019.
//  Copyright © 2019 fahid.attique. All rights reserved.
//

import UIKit

public class InteractiveView: UIView {
    
    //MARK: Static Properties
    static var transformationOriginalSize = CGAffineTransform(scaleX: 1, y: 1)
    static var transformationShrinkSize = CGAffineTransform(scaleX: 0.95, y: 0.95)
    static var overlayColor = UIColor.black.withAlphaComponent(0.08)
    static var animationDuration: TimeInterval = 0.0
    static var dampingRatio: CGFloat = 1.0
    static var initialVelocity = CGVector(dx: 0.2, dy: 0.2)
    
    //MARK: Class Properties
    private var overlayView: UIView!

    //MARK: Life Cycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInIt()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInIt()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchMoved(touch: touches.first)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        touchMoved(touch: touches.first)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEnded(touch: touches.first)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchEnded(touch: touches.first)
    }
    
    //MARK: Functions
    private func commonInIt() {
        
        overlayView = UIView(frame: bounds)
        overlayView.backgroundColor = InteractiveView.overlayColor
        overlayView.isHidden = true
        addSubview(overlayView)
    }
    
    private func touchMoved(touch: UITouch?) {
        
        guard let touch = touch else { return }
        let locationInSelf = touch.location(in: self)
        if !bounds.contains(locationInSelf) {
            performTransformation(InteractiveView.transformationOriginalSize, hideOverlay: true)
            return
        }
        performTransformation(InteractiveView.transformationShrinkSize, hideOverlay: false)
    }

    private func touchEnded(touch: UITouch?) {
        performTransformation(InteractiveView.transformationOriginalSize, hideOverlay: true)
    }

    private func performTransformation(_ transformation: CGAffineTransform, hideOverlay: Bool) {

        let timingParameters = UISpringTimingParameters(dampingRatio: InteractiveView.dampingRatio, initialVelocity: InteractiveView.initialVelocity)
        let animator = UIViewPropertyAnimator(duration: InteractiveView.animationDuration, timingParameters: timingParameters)
        animator.addAnimations { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.transform = transformation
            weakSelf.overlayView.isHidden = hideOverlay
        }
        animator.isInterruptible = true
        animator.startAnimation()
    }
}
