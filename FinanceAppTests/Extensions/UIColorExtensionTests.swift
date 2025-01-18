
import XCTest
import UIKit
@testable import FinanceApp

class UIColorExtensionTests: XCTestCase{
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testColorToFromDataTransform(){
        
        var colorData = UIColor.cyan.data
        XCTAssertEqual(UIColor(data: colorData), UIColor.cyan)
        
        colorData = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5).data
        let colorComponents = UIColor(data: colorData)?.cgColor.components
        
        XCTAssertEqual(colorComponents![0], 0.5)
        XCTAssertEqual(colorComponents![1], 0.5)
        XCTAssertEqual(colorComponents![2], 0.5)
        XCTAssertEqual(colorComponents![3], 0.5)
    }
    
}
