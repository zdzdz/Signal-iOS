//
//  PhysicsTransitionManager.swift
//  Signal
//
//  Created by Sam Son on 2/5/16.
//  Copyright © 2016 zdzdz. All rights reserved.
//

import UIKit

@objc class PhysicsTransitionManager: TKSideDrawerTransition {
    var animator : UIDynamicAnimator!
    var gravity  : UIGravityBehavior!
    var collision : UICollisionBehavior!
    
    override init(sideDrawer: TKSideDrawer) {
        super.init(sideDrawer: sideDrawer)
        animator = UIDynamicAnimator(referenceView: (sideDrawer.superview)!)
        gravity = UIGravityBehavior(items: [sideDrawer])
        collision = UICollisionBehavior(items: [sideDrawer])
    }
    
    override init()
    {
        super.init()
    }
    
    override func show() {
        self.transitionBegan(true)
        self.sideDrawer?.frame = CGRect(x: -250, y: 0, width: (self.sideDrawer?.width)!, height: (self.sideDrawer?.superview?.bounds.height)!)
        self.sideDrawer?.hidden = false
        
        self.animator = UIDynamicAnimator(referenceView: (self.sideDrawer?.superview)!)
        gravity = UIGravityBehavior(items: [self.sideDrawer!])
        gravity.gravityDirection = CGVector(dx: 1.0, dy: 0.0)
        gravity.magnitude = 2;
        
        collision.addBoundaryWithIdentifier("Bound", fromPoint: CGPoint(x: 250, y: 0), toPoint: CGPoint(x: 250, y: (self.sideDrawer?.superview?.bounds.height)!))
        animator.addBehavior(collision)
        
        animator.addBehavior(gravity)
        
        let itemBehavior = UIDynamicItemBehavior(items: [self.sideDrawer!])
        itemBehavior.elasticity = 0.5
        animator.addBehavior(itemBehavior)
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            self.sideDrawer?.hostview?.center = CGPoint(x: (self.sideDrawer?.hostview?.center.x)! + (self.sideDrawer?.width)!, y:(self.sideDrawer?.hostview?.center.y)! )
            }) { (finished) -> Void in
                self.transitionEnded(true)
        }
    }
    
    override func dismiss() {
        self.transitionBegan(true)
        
        UIView.animateWithDuration(0.9, animations: { () -> Void in
            self.sideDrawer?.hostview?.center = CGPoint(x: CGRectGetMidX((self.sideDrawer?.hostview?.superview?.bounds)!), y: CGRectGetMidY((self.sideDrawer?.hostview?.superview?.bounds)!))
            }) { (finished) -> Void in
                self.transitionEnded(false)
        }
        
        gravity.gravityDirection = CGVector(dx: -1.0, dy: 0.0)
        gravity.magnitude = 4;
        collision.removeAllBoundaries()
        collision.addBoundaryWithIdentifier("leftBound", fromPoint: CGPoint(x: -270, y: 0), toPoint: CGPoint(x: -270, y: (self.sideDrawer?.superview?.bounds.height)!))
    }
}
