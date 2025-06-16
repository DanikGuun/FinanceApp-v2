

import XCTest
@testable import FinanceApp

final class EditCategoryModelTests: XCTestCase {
    
    fileprivate var database: MockCategoryDatabase!
    fileprivate var iconProvider: MockIconProvider!
    fileprivate var colorProvider: MockColorProvider!
    var model: EditCategoryModel!
    
    override func setUp() {
        database = MockCategoryDatabase()
        iconProvider = MockIconProvider()
        colorProvider = MockColorProvider()
        model = EditCategoryModel(editingCategoryId: UUID(), categoryDatabase: database, iconProvider: iconProvider, colorProvider: colorProvider)
        super.setUp()
    }
    
    override func tearDown() {
        database = nil
        iconProvider = nil
        colorProvider = nil
        model = nil
        super.tearDown()
    }
    
    func testEditCategory() {
        let initialCategory = DefaultCategory(name: "first")
        let categoryId = database.addCategory(initialCategory)!.id
        let updatedCategory = DefaultCategory(name: "Updated")
        
        model.editingCategoryId = categoryId
        model.perform(category: updatedCategory)
        
        let fetchedCategory = database.getCategory(id: categoryId)
        XCTAssertEqual(fetchedCategory?.name, "Updated")
    }
    
    func testDeleteCategory() {
        let categoryId = database.addCategory(DefaultCategory(name: "first"))!.id
        let count = database.getAllCategories().count
        
        XCTAssertEqual(count, 1)
        
        model.editingCategoryId = categoryId
        model.removeCategory()
        
        XCTAssertNil(database.getCategory(id: categoryId))
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
        return categories.first(where: { $0.id == id })
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
        let index = categories.firstIndex(where: { $0.id == id })!
        let newCategory = DefaultCategory(id: id, name: newCategory.name, type: newCategory.type, iconID: newCategory.iconID, color: newCategory.color)
        categories[index] = newCategory
    }
    
    func removeCategory(id: UUID) {
        categories.removeAll(where: { $0.id == id })
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
