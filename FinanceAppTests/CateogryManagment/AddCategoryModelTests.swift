

import XCTest
@testable import FinanceApp

final class AddCategoryModelTests: XCTestCase {
    
    fileprivate var database: MockCategoryDatabase!
    var model: AddCategoryModel!
    
    override func setUp() {
        database = MockCategoryDatabase()
        model = AddCategoryModel(categoryDatabase: database)
        super.setUp()
    }
    
    override func tearDown() {
        database = nil
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
        let identifiableCategory = DefaultCategory(name: category.name, type: category.type, iconID: category.iconID, color: category.color)
        categories.append(identifiableCategory)
        return identifiableCategory
    }
    
    func updateCategory(id: UUID, with newCategory: any FinanceApp.Category) {
        
    }
    
    func removeCategory(_ category: any FinanceApp.IdentifiableCategory) {
        
    }
    
    
}
