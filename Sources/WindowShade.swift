import UIKit

/// `WindowShade` is a view with slide functionality.
///
/// `WindowShade` slides down and up when `slideDown(completion:)` and `slideUp(completion:)` are called. Other than that, it has a
/// `swipeGestureRecognizer` so that a user can swipe up to slide it up. You can change the duration of slide by changing the value of
/// `slideDuration`.
public class WindowShade: UIView {
    /// The duration of the slide.
    ///
    /// The default value is `UINavigationControllerHideShowBarDuration`.
    public var slideDuration: TimeInterval = TimeInterval(UINavigationControllerHideShowBarDuration)
    
    /// A Boolean value that indicates if the `windowShade` is down.
    ///
    /// It's true after the `windowShade` completes sliding down and before it completes sliding up.
    internal(set) public var isDown: Bool = false
    
    /// A Boolean value that indicates if the `windowShade` is sliding.
    internal(set) public var isSliding: Bool = false
    
    /// The swipe gesture recognizer that supports sliding up with swipe-up gesture.
    private(set) public var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
        self.swipeGestureRecognizer.direction = .up
        self.addGestureRecognizer(self.swipeGestureRecognizer)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// The action of `swipeGestureRecognizer` which simply calls `slideUp()`.
    @objc private func handleSwipeGesture() {
        self.slideUp()
    }
    
    /// Slide down the `windowShade`.
    ///
    /// It only works when both `isDown` and `isSliding` are false.
    ///
    /// - parameter completion: A block object to be executed when the `windowShade` completes sliding down.
    internal func slideDown(completion: ((Bool) -> Void)? = nil) {
        if !self.isDown && !self.isSliding {
            self.isSliding = true
            UIView.animate(withDuration: self.slideDuration, animations: {
                self.frame.origin.y = 0
            }, completion: { (complete) in
                self.isSliding = false
                if complete {
                    self.isDown = true
                }
                
                if let completion = completion {
                    completion(complete)
                }
            })
        } else {
            if let completion = completion {
                completion(false)
            }
        }
    }
    
    /// Slide up the `windowShade`.
    ///
    /// It only works when `isDown` is true and `isSliding` is false.
    ///
    /// - parameter completion: A block object to be executed when the `windowShade` completes sliding up.
    internal func slideUp(completion: ((Bool) -> Void)? = nil) {
        if self.isDown && !self.isSliding {
            self.isSliding = true
            UIView.animate(withDuration: self.slideDuration, animations: {
                self.frame.origin.y = -self.frame.height
            }, completion: { complete in
                self.isSliding = false
                if complete {
                    self.isDown = false
                }
                
                if let completion = completion {
                    completion(complete)
                }
            })
        } else {
            if let completion = completion {
                completion(false)
            }
        }
    }
}
