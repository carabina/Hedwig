import UIKit

/// `Hedwig` shows notification and enables users to handle it.
///
/// `Hedwig` works as a singleton, and you talk to `shared` directly to change properties like height, color, display duration, etc. Basically,
/// `Hedwig` uses a `windowShade` as a carrier for all other objects, and shows notification by sliding down the `windowShade`.
///
/// When `show(notification:, handler:, completion:)` is called, it depends on the value of `displayDuration` to determine whether the
/// notification will hide automatically. If it's positive, the notification will hide automatically after that duration. Otherwise, you need
/// to call `hide(completion:)` specifically to hide it. Of course, you can hide it manually before it hides automatically.
///
/// Instead of just showing notifications, `Hedwig` has a `tapGestureRecognizer` to enable users to handle the notification. You can pass the
/// action to the `handler` when calling `show(notification:, handler:, completion:)`.
public class Hedwig: NSObject {
    /// The singleton that actually does the job.
    public static let shared: Hedwig = Hedwig()
    
    /// The duration that the notification stays on screen after showing and before hiding automatically.
    ///
    /// If the value is non-positive, the notification won't hide automatically. The default value is 0.
    public var displayDuration: TimeInterval = 0
    
    /// The window that the `windowShade` is attached to.
    private(set) public var window: UIWindow!
    
    /// The window shade that carries all other objects.
    private(set) public var windowShade: WindowShade!
    
    /// The label that shows the notification.
    private(set) public var label: UILabel!
    
    /// The tap gesture recognizer that handles user interaction.
    private(set) public var tapGestureRecognizer: UITapGestureRecognizer!
    
    /// The height of the `windowShade`, making sure the heights of the `window`, `windowShade`, and `label` are coherent.
    ///
    /// The `window` and `windowShade` always have the same height, while the height of the `label` depends on the relation between the height
    /// of the `windowShade` and its font size. The `label` tries to keep a 5-point margin to each edges of the `windowShade`. If this isn't
    /// feasible, it will keep the margin as large as possible.
    ///
    /// It can't be set when the `windowShade` is visible. The default value is 64.
    public var height: CGFloat {
        get {
            return self.window.bounds.height
        }
        set {
            if !self.windowShade.isDown && !self.windowShade.isSliding {
                if (newValue - self.label.font.pointSize) / 2 < 0 {
                    self.label.frame.size.height = newValue
                    self.label.font = UIFont.systemFont(ofSize: newValue)
                } else if (newValue - self.label.font.pointSize) / 2 > 5 {
                    self.label.frame.size.height = newValue - 10
                } else {
                    self.label.frame.size.height = self.label.font.pointSize
                }
                self.label.frame.origin.y = (newValue - self.label.frame.size.height) / 2
                
                self.windowShade.frame.size.height = newValue
                
                self.window = self.window(height: newValue)
            }
        }
    }
    
    private override init() {
        super.init()
        self.windowShade = WindowShade(frame: CGRect(x: 0, y: -64, width: UIScreen.main.bounds.width, height: 64))
        self.windowShade.backgroundColor = UIColor.black
        
        self.window = self.window(height: 64)
        
        self.label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: 64))
        self.label.numberOfLines = 0
        self.label.textColor = UIColor.white
        self.label.textAlignment = .center
        self.windowShade.addSubview(self.label)
        
        self.tapGestureRecognizer = UITapGestureRecognizer()
        self.tapGestureRecognizer.addTarget(self, action: #selector(handleTapGesture))
        self.windowShade.addGestureRecognizer(self.tapGestureRecognizer)
    }
    
    /// Return a `UIWindow` with specified height.
    ///
    /// It's used for changing the height of the `window`.
    ///
    /// - parameter height: The height of the window to be returned.
    private func window(height: CGFloat) -> UIWindow {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        window.windowLevel = UIWindowLevelStatusBar + 1
        window.addSubview(self.windowShade)
        
        return window
    }
    
    /// The handler that handles tap gesture.
    ///
    /// It's `nil` when the `windowShade` is invisible.
    internal var tapGestureHandler: ((Void) -> Void)?
    
    /// The action of `tapGestureRecognizer` which simply calls `tapGestureHandler()`.
    @objc private func handleTapGesture() {
        if let tapGestureHandler = self.tapGestureHandler {
            tapGestureHandler()
        }
    }
    
    /// Show the notification to the user.
    ///
    /// Only if `displayDuration` is positive will it call `hide(completion:)` automatically. If `handler` is not nil, it will be executed when
    /// the user taps the `windowShade`.
    ///
    /// - parameter notification: The notification to be shown to the user.
    /// - parameter handler: The action to be taken when the user taps the `windowShade`.
    /// - parameter completion: A block object to be executed when the `windowShade` completes sliding down. If the notification hides
    /// automatically, it will be executed after the `windowShade` completes sliding up.
    public class func show(notification: String, handler: ((Void) -> Void)? = nil, completion: ((Bool) -> Void)? = nil) {
        if !self.shared.windowShade.isDown && !self.shared.windowShade.isSliding {
            self.shared.label.text = notification
            self.shared.tapGestureHandler = handler
            self.shared.window.isHidden = false

            self.shared.windowShade.slideDown { (complete) in
                if !complete {
                    self.shared.window.isHidden = true
                    self.shared.tapGestureHandler = nil
                    self.shared.label.text = nil
                }
                
                if self.shared.displayDuration > 0 {
                    Timer.scheduledTimer(withTimeInterval: self.shared.displayDuration, repeats: false, block: { (timer) in
                        Hedwig.hide(completion: completion)
                    })
                }
                
                if let completion = completion {
                    completion(complete)
                }
            }
        }
    }
    
    /// Hide the notification.
    ///
    /// - parameter completion: A block object to be executed when the `windowShade` completes sliding up.
    public class func hide(completion: ((Bool) -> Void)? = nil) {
        self.shared.windowShade.slideUp { (complete) in
            self.shared.window.isHidden = true
            self.shared.tapGestureHandler = nil
            self.shared.label.text = nil
            
            if let completion = completion {
                completion(complete)
            }
        }
    }
}
