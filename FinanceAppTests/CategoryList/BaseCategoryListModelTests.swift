

import XCTest
@testable import FinanceApp

final class BaseCategoryListModelTests: XCTestCase {
    
    fileprivate var categoryDatabase: MockCategoryDatabase!
    fileprivate var iconProvider: MockIconProvider!
    var model: BaseCategoryListModel!
    
    override func setUp() {
        categoryDatabase = MockCategoryDatabase()
        iconProvider = MockIconProvider()
        model = BaseCategoryListModel(categoryDatabase: categoryDatabase, iconProvider: iconProvider)
        super.setUp()
    }
    
    override func tearDown() {
        categoryDatabase = nil
        iconProvider = nil
        model = nil
        super.tearDown()
    }
    
    func testFetchExpenceCategories() {
        categoryDatabase.categories = [
            DefaultCategory(type: .expense), DefaultCategory(type: .expense),
            DefaultCategory(type: .income), DefaultCategory(type: .income), DefaultCategory(type: .income)
        ]
        let categories = model.getCategories(type: .expense)
        XCTAssertEqual(categories.count, 2)
    }
    
    func testFetchIncomeCategories() {
        categoryDatabase.categories = [
            DefaultCategory(type: .expense), DefaultCategory(type: .expense),
            DefaultCategory(type: .income), DefaultCategory(type: .income), DefaultCategory(type: .income)
        ]
        let categories = model.getCategories(type: .income)
        XCTAssertEqual(categories.count, 3)
    }
    
    func testFetchIcon() {
        iconProvider.icons = [DefaultIcon(id: "icon", image: UIImage(systemName: "plus")!, kind: .base)]
        let icon = model.getImage(iconId: "icon")
        XCTAssertEqual(icon, UIImage(systemName: "plus"))
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
        categories.filter { $0.type == type }
    }
    
    func addCategory(_ category: any FinanceApp.Category) -> (any FinanceApp.IdentifiableCategory)? {
        return nil
    }
    
    func updateCategory(id: UUID, with newCategory: any FinanceApp.Category) {
        
    }
    
    func removeCategory(id: UUID) {
        
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
        return [:]
    }
    
    
}
