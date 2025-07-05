

import XCTest
@testable import FinanceApp

final class AddCategoryModelTests: XCTestCase {
    
    fileprivate var database: MockCategoryDatabase!
    fileprivate var iconProvider: MockIconProvider!
    fileprivate var colorProvider: MockColorProvider!
    var model: AddCategoryModel!
    
    override func setUp() {
        database = MockCategoryDatabase()
        iconProvider = MockIconProvider()
        colorProvider = MockColorProvider()
        model = AddCategoryModel(categoryDatabase: database, iconProvider: iconProvider, colorProvider: colorProvider)
        super.setUp()
    }
    
    override func tearDown() {
        database = nil
        iconProvider = nil
        colorProvider = nil
        model = nil
        super.tearDown()
    }
    
    func testAddCategory() {
        let startCount = database.getAllCategories().count
        XCTAssertEqual(startCount, 0)
        
        model.perform(category: DefaultCategory())
        
        let endCount = database.getAllCategories().count
        XCTAssertEqual(endCount, 1)
    }
    
    func testFetchIcon() {
        iconProvider.icons = [DefaultIcon(id: "Icon", image: UIImage(), kind: .base)]
        let icon = model.getIcon(id: "Icon")
        XCTAssertNotNil(icon)
    }
    
    func testFetchColor() {
        colorProvider.colors = [.black]
        let count = model.getColors().count
        XCTAssertEqual(count, 1)
    }
    
}

fileprivate class MockCategoryDatabase: CategoryDatabase {
    
    var categories: [any FinanceApp.IdentifiableCategory] = []
    
    func getCategory(id: UUID) -> (any FinanceApp.IdentifiableCategory)? {
        return nil
    }
    
    func getAllCategories() -> [any FinanceApp.IdentifiableCategory] {
        return categories
    }
    
    func getCategories(of type: FinanceApp.CategoryType) -> [any FinanceApp.IdentifiableCategory] {
        return []
    }
    
    func addCategory(_ category: any FinanceApp.Category) -> (any FinanceApp.IdentifiableCategory)? {
        let identifiableCategory = DefaultCategory(name: category.name, type: category.type, iconId: category.iconId, color: category.color)
        categories.append(identifiableCategory)
        return identifiableCategory
    }
    
    func updateCategory(id: UUID, with newCategory: any FinanceApp.Category) {
        
    }
    
    func removeCategory(id: UUID) {
        
    }
    
}

fileprivate class MockIconProvider: IconProvider {
    
    var icons: [any FinanceApp.Icon] = []
    
    func getIcons() -> [any FinanceApp.Icon] {
        return []
    }
    
    func getIcon(id: String) -> (any FinanceApp.Icon)? {
        return icons.first { $0.id == id }
    }
    
    func getIconsWithKind() -> [FinanceApp.IconKind : [any FinanceApp.Icon]] {
        return [:]
    }

}

fileprivate class MockColorProvider: ColorProvider {
    
    var colors: [UIColor] = []
    
    func getColors() -> [UIColor] {
        return colors
    }
    
    
}
