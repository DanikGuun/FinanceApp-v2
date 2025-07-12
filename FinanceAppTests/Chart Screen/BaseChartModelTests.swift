

import XCTest
@testable import FinanceApp

final class BaseChartModelTests: XCTestCase {
    
    fileprivate var database: MockDatabase!
    var model: BaseChartModel!
    
    override func setUp() {
        database = MockDatabase()
        model = BaseChartModel(database: database)
        super.setUp()
    }
    
    override func tearDown() {
        database = nil
        model = nil
        super.tearDown()
    }
    
    func testGetCategoryMeta() {
        let category = DefaultCategory(id: UUID(), name: "Test")
        let meta = [TransactionCategoryMeta(category: category, amount: 1, percentage: 35), TransactionCategoryMeta(category: category, amount: 31, percentage: 355)]
        
        database.transactionCategoryMeta = meta
        let fetchedMeta = model.getCategoriesSummary(type: .expense, interval: nil)
        
        XCTAssertEqual(fetchedMeta, meta)
    }
    
    func testGetIcon() {
        let icon = DefaultIcon(id: "icon")
        database.icons = [icon]
        
        let fetchedIcon = model.getIcon(iconId: "icon")
        
        XCTAssertEqual(fetchedIcon, icon.image)
    }
    
}

fileprivate class MockDatabase: DatabaseFacade {
    
    var moneyOffset: Double = 0.0
    var transactionCategoryMeta: [FinanceApp.TransactionCategoryMeta] = []
    var icons: [any Icon] = []
    
    func totalAmount(_ type: FinanceApp.CategoryType, for interval: DateInterval?) -> Double {
        return -1000
    }
    
    func categoriesSummary(_ type: FinanceApp.CategoryType, for interval: DateInterval?) -> [FinanceApp.TransactionCategoryMeta] {
        return transactionCategoryMeta
    }
    
    func getTransaction(id: UUID) -> (any FinanceApp.IdentifiableTransaction)? { nil }
    func getAllTransactions(interval: DateInterval?) -> [any FinanceApp.IdentifiableTransaction] { [] }
    func getTransactions(interval: DateInterval?, categoryId: UUID) -> [any FinanceApp.IdentifiableTransaction] { [] }
    func addTransaction(_ transaction: any FinanceApp.Transaction) -> (any FinanceApp.IdentifiableTransaction)? { nil }
    func updateTransaction(id: UUID, with newTransaction: any FinanceApp.Transaction) {}
    func removeTransaction(id: UUID) {}
    func getCategory(id: UUID) -> (any FinanceApp.IdentifiableCategory)? { nil }
    func getAllCategories() -> [any FinanceApp.IdentifiableCategory] { [] }
    func getCategories(of type: FinanceApp.CategoryType) -> [any FinanceApp.IdentifiableCategory] { [] }
    func addCategory(_ category: any FinanceApp.Category) -> (any FinanceApp.IdentifiableCategory)? { nil }
    func updateCategory(id: UUID, with newCategory: any FinanceApp.Category) {}
    func removeCategory(id: UUID) {}
    func getIcons() -> [any FinanceApp.Icon] {
        return icons
    }
    func getIcon(id: String) -> (any FinanceApp.Icon)? {
        return icons.first { $0.id == id }
    }
    func getIconsWithKind() -> [FinanceApp.IconKind : [any FinanceApp.Icon]] { [:] }
    func getColors() -> [UIColor] { [] }
    
    
}
