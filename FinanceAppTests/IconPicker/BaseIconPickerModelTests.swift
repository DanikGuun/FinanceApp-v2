

import XCTest
@testable import FinanceApp

final class BaseIconPickerModelTests: XCTestCase {
    
    fileprivate var iconProvider: MockIconProvider!
    var model: BaseIconPickerModel!
    
    override func setUp() {
        iconProvider = MockIconProvider()
        model = BaseIconPickerModel(iconProvider: iconProvider, startColor: .black)
        super.setUp()
    }
    
    override func tearDown() {
        iconProvider = nil
        model = nil
        super.tearDown()
    }
    
    func testGetSections() {
        iconProvider.icons = [
            DefaultIcon(id: "id1", image: UIImage(), kind: .base),
            DefaultIcon(id: "id2", image: UIImage(), kind: .base)
        ]
        let sections = model.getSections()
        XCTAssertEqual(sections.count, 1)
        XCTAssertEqual(sections.first?.icons.count, 2)
    }
    
}

fileprivate class MockIconProvider: IconProvider {
    
    var icons: [any Icon] = []
    
    func getIcons() -> [any FinanceApp.Icon] {
        return icons
    }
    
    func getIcon(id: String) -> (any FinanceApp.Icon)? {
        return icons.first { $0.id == id }
    }
    
    func getIconsWithKind() -> [FinanceApp.IconKind : [any FinanceApp.Icon]] {
        var dict: [IconKind : [any Icon]] = [:]
        icons.forEach { dict[$0.kind, default: []].append($0) }
        return dict
    }
    
    
}
