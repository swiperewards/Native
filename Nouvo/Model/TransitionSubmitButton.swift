import Foundation
import UIKit

@IBDesignable
open class TKTransitionSubmitButton : UIButton, UIViewControllerTransitioningDelegate, CAAnimationDelegate {
    
    lazy var spiner: SpinerLayers! = {
        let s = SpinerLayers(frame: self.frame)
        self.layer.addSublayer(s)
        return s
    }()
    
    @IBInspectable open var spinnerColor: UIColor = UIColor.white {
        didSet {
            spiner.spinnerColor = spinnerColor
        }
    }
    
    open var didEndFinishAnimation : (()->())? = nil

    let springGoEase = CAMediaTimingFunction(controlPoints: 0.45, -0.36, 0.44, 0.92)
    let shrinkCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    let expandCurve = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    let shrinkDuration: CFTimeInterval  = 0.1
    @IBInspectable open var normalCornerRadius:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = normalCornerRadius
        }
    }

    var cachedTitle: String?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }

    func setup() {
        self.clipsToBounds = true
        spiner.spinnerColor = spinnerColor
    }

    open func startLoadingAnimation() {
        self.cachedTitle = title(for: UIControlState())
        self.setTitle("", for: UIControlState())
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.layer.cornerRadius = self.frame.height / 2
            }, completion: { (done) -> Void in
                self.shrink()
                Timer.schedule(delay: self.shrinkDuration - 0.25) { timer in
                    self.spiner.animation()
                }
        }) 
        
    }

    open func startFinishAnimation(_ delay: TimeInterval,_ animation: CAMediaTimingFunction, completion:(()->())?) {
        Timer.schedule(delay: delay) { timer in
            self.didEndFinishAnimation = completion
            self.expand(animation)
            self.spiner.stopAnimation()
        }
    }
    open func startFinishAnimations(_ delay: TimeInterval,_ animation: CAMediaTimingFunction, completion:(()->())?) {
        Timer.schedule(delay: delay) { timer in
            self.didEndFinishAnimation = completion
            self.expands(animation)
            self.spiner.stopAnimation()
        }
    }

    open func animate(_ duration: TimeInterval,_ animation: CAMediaTimingFunction, completion:(()->())?) {
        startLoadingAnimation()
        startFinishAnimation(duration, animation, completion: completion)
    }

    open func animates(_ duration: TimeInterval,_ animation: CAMediaTimingFunction, completion:(()->())?) {
        startLoadingAnimation()
        startFinishAnimations(duration, animation, completion: completion)
    }

    open func setOriginalState() {
        self.returnToOriginalState()
        self.spiner.stopAnimation()
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let a = anim as! CABasicAnimation
        if a.keyPath == "transform.scale" {
            didEndFinishAnimation?()
            Timer.schedule(delay: 1) { timer in
                self.returnToOriginalState()
            }
        }
    }
    
    open func returnToOriginalState() {
        
        self.layer.removeAllAnimations()
        self.setTitle(self.cachedTitle, for: UIControlState())
        self.spiner.stopAnimation()
    }
    
    func shrink() {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = frame.width
        shrinkAnim.toValue = frame.height
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = kCAFillModeForwards
        shrinkAnim.isRemovedOnCompletion = false
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }
    
    func expand(_ animation: CAMediaTimingFunction) {
        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        expandAnim.fromValue = 1.0
        expandAnim.toValue = 1.0
        expandAnim.timingFunction = animation
        expandAnim.duration = 0.1
        expandAnim.delegate = self
        expandAnim.fillMode = kCAFillModeForwards
        expandAnim.isRemovedOnCompletion = false
        layer.add(expandAnim, forKey: expandAnim.keyPath)
    }
    func expands(_ animation: CAMediaTimingFunction) {
        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        expandAnim.fromValue = 1.0
        expandAnim.toValue = 26.0
        expandAnim.timingFunction = animation
        expandAnim.duration = 0.1
        expandAnim.delegate = self
        expandAnim.fillMode = kCAFillModeForwards
        expandAnim.isRemovedOnCompletion = false
        layer.add(expandAnim, forKey: expandAnim.keyPath)
    }
    
}
