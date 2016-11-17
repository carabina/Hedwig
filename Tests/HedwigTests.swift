import XCTest
@testable import Hedwig

// Since `Hedwig` is a singleton, all the tests should be executed separately.
class HedwigTests: XCTestCase {
    func testHeight() {
        let height: CGFloat = 20
        Hedwig.shared.height = height
        XCTAssertFalse(Hedwig.shared.windowShade.isSliding)
        XCTAssertFalse(Hedwig.shared.windowShade.isDown)
        XCTAssertEqual(Hedwig.shared.window.bounds.height, height)
        XCTAssertEqual(Hedwig.shared.windowShade.bounds.height, height)
        XCTAssertLessThanOrEqual(Hedwig.shared.label.bounds.height, height)
    }
    
    func testHideAutomatically() {
        Hedwig.shared.displayDuration = 1
        Hedwig.show(notification: "Hi", handler: nil) { (complete) in
            XCTAssertTrue(Hedwig.shared.window.isHidden)
            XCTAssertNil(Hedwig.shared.tapGestureHandler)
            XCTAssertNil(Hedwig.shared.label.text)
        }
    }
}
