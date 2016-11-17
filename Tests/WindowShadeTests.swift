import XCTest
@testable import Hedwig

class WindowShadeTests: XCTestCase {
    var windowShade: WindowShade!
    
    override func setUp() {
        super.setUp()
        
        self.windowShade = WindowShade(frame: CGRect(x: 0, y: -64, width: UIScreen.main.bounds.width, height: 64))
    }
    
    func testSlideDown() {
        self.windowShade.slideDown { (complete) in
            XCTAssertTrue(complete)
            XCTAssertEqual(self.windowShade.frame.origin.y, 0)
            XCTAssertTrue(self.windowShade.isDown)
            XCTAssertFalse(self.windowShade.isSliding)
        }
    }
    
    func testSlidingDownFailsWhenSliding() {
        self.windowShade.isSliding = true
        self.windowShade.slideDown { (complete) in
            XCTAssertFalse(complete)
            XCTAssertEqual(self.windowShade.frame.origin.y, -self.windowShade.frame.height)
            XCTAssertFalse(self.windowShade.isDown)
            XCTAssertTrue(self.windowShade.isSliding)
        }
    }
    
    func testSlidingDownFailsWhenDown() {
        self.windowShade.isDown = true
        self.windowShade.slideDown { (complete) in
            XCTAssertFalse(complete)
            XCTAssertEqual(self.windowShade.frame.origin.y, -self.windowShade.frame.height)
            XCTAssertTrue(self.windowShade.isDown)
            XCTAssertFalse(self.windowShade.isSliding)
        }
    }
    
    func testSlideUp() {
        self.windowShade.frame.origin.y = 0
        self.windowShade.isDown = true
        self.windowShade.slideUp { (complete) in
            XCTAssertTrue(complete)
            XCTAssertEqual(self.windowShade.frame.origin.y, -self.windowShade.frame.height)
            XCTAssertFalse(self.windowShade.isDown)
            XCTAssertFalse(self.windowShade.isSliding)
        }
    }
    
    func testSlidingUpFailsWhenSliding() {
        self.windowShade.frame.origin.y = 0
        self.windowShade.isDown = true
        self.windowShade.isSliding = true
        self.windowShade.slideUp { (complete) in
            XCTAssertFalse(complete)
            XCTAssertEqual(self.windowShade.frame.origin.y, 0)
            XCTAssertTrue(self.windowShade.isDown)
            XCTAssertTrue(self.windowShade.isSliding)
        }
    }
    
    func testSlidingUpFailsWhenUp() {
        self.windowShade.frame.origin.y = 0
        self.windowShade.isDown = false
        self.windowShade.slideUp { (complete) in
            XCTAssertFalse(complete)
            XCTAssertEqual(self.windowShade.frame.origin.y, 0)
            XCTAssertFalse(self.windowShade.isDown)
            XCTAssertFalse(self.windowShade.isSliding)
        }
    }
}
