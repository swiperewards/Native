//
//  FRStretchView.swift
//  FRStretchView
//
//  Created by Felipe Ricieri on 09/03/17.
//  Copyright © 2017 Ricieri Labs. All rights reserved.
//

import Foundation
import UIKit

/**
 FRStretchView: an easy way to add a pull-to-stretch behavior to your UIView
 (Similar to FRStretchImageView)
 */
public class FRStretchView : UIView {
    
    /**
     debug: Set it to TRUE if you want to receive logs
     */
    public var debug = true
    
    /**
     Constraints we need to change in order to get the "stretch" behavior
     */
    public var topConstraint: NSLayoutConstraint! {
        didSet {
            // Automatically sets the initial value for Top
            topInitialValue = topConstraint.constant
        }
    }
    public var heightConstraint: NSLayoutConstraint! {
        didSet {
            // Automatically sets the initial value for Height
            heightInitialValue = heightConstraint.constant
        }
    }
    
    /**
     ScrollView observed by the ImageView
     */
    fileprivate var scrollView : UIScrollView!
    
    /**
     We also need to keep the constraint's initial value
     */
    fileprivate var topInitialValue : CGFloat!
    fileprivate var heightInitialValue : CGFloat!
    
    /**
     KVO tools
     */
    fileprivate var context = 20_06_87
    fileprivate let keyPathObserved = "contentOffset"
    
    
    // MARK: - Initialization
    
    
    /**
     Stretch Height (when pulled by scrollView)
     
     Adds a \"pull-to-stretch\" behavior on this UIView. It requires your UIView be a child of the given UIScrollView.
     
     @param scrollView: UIScrollView
     */
    public func stretchHeightWhenPulledBy(scrollView: UIScrollView) {
        
        // Inform log
        if  debug {
            print("FRStretchView: was allocated")
        }
        
        // Set the scrollView
        self.scrollView = scrollView
        
        // ScrollView settings
        assert(self.scrollView != nil, "FRStretchView: scrollView cannot be nil")
        self.scrollView.clipsToBounds = true
        self.scrollView.addObserver(self, forKeyPath: self.keyPathObserved, options: [.new], context: &self.context)
        
        // ImageView settings
        assert(self.superview != nil, "FRStretchView: imageView has no superview")
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        
        // 1) Find top constraint
        if  let hasSuperview = self.superview {
            let constraints = hasSuperview.constraints
            for constraint in constraints {
                if  constraint.firstAttribute == .top
                &&  constraint.relation == .equal
                && (constraint.firstItem as! NSObject) == self
                && (constraint.secondItem as! NSObject) == hasSuperview  {
                    self.topConstraint = constraint
                }
            }
        }
        
        // 2) Find height constraint
        let selfConstraints = self.constraints
        for constraint in selfConstraints {
            if  constraint.firstAttribute == .height
                &&  constraint.relation == .equal {
                self.heightConstraint = constraint
            }
        }
    }
    
    deinit {
        
        // Print log
        if  debug {
            print("FRStretchView: was deallocated")
        }
        
        // Remove observer
        self.scrollView.removeObserver(self, forKeyPath: self.keyPathObserved, context: &self.context)
        
        // Freeing ARC
        self.scrollView = nil
        self.topConstraint = nil
        self.heightConstraint = nil
    }
}

// MARK: - KVO
extension FRStretchView {
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // We make sure everything was set
        assert(self.topConstraint != nil, "FRStretchView: imageView must have a top constraint pinned to top of superview. Use Interface Builder to pin it.")
        assert(self.heightConstraint != nil, "FRStretchView: imageView must have a height constraint pinned on it. Use Interface Builder to pin it.")
        
        if  let changeDict = change {
            
            // This is our scope
            if  object as? NSObject == self.scrollView
                &&  keyPath == self.keyPathObserved
                &&  context == &self.context {
                
                // We will only proceed in case we have the correct new value as CGPoint
                if  let new = changeDict[.newKey],
                    let newContentOffset = (new as AnyObject).cgPointValue {
                    
                    // Print log
                    if  debug {
                        print("FRStretchView: New Content Offset --> \(newContentOffset)")
                    }
                    
                    // if offset y is higher than 0, we keep the initial values
                    if  newContentOffset.y > 0 {
                        self.topConstraint.constant = self.topInitialValue
                        self.heightConstraint.constant = self.heightInitialValue
                    }
                        // if it isn't, we do our math
                    else {
                        let dif = CGFloat(abs(Int32(newContentOffset.y)))
                        self.heightConstraint.constant = self.heightInitialValue + dif
                        self.topConstraint.constant = newContentOffset.y
                    }
                }
            }
        }
    }
}

