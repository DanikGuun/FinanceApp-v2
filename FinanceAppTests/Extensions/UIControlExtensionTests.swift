
import XCTest
@testable import FinanceApp

class UIControlExtensionTests: XCTestCase {
  
    func testRemoveAllActions(){
        
        let control = UIControl()
        var actionsCount: Int {
            var count = 0
            control.enumerateEventHandlers(({_, _, _, _ in count += 1}))
            return count
        }
        
        control.addAction(UIAction(handler: {_ in }), for: .touchUpInside)
        XCTAssertEqual(actionsCount, 1)
        
        control.removeAllActions()
        XCTAssertEqual(actionsCount, 0)
    }
    
}
