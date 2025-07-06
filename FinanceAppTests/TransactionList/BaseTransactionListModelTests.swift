

import XCTest
@testable import FinanceApp

final class BaseTransactionListModelTests: XCTestCase {
    
    fileprivate var database: MockDatabase!
    var model: BaseTransactionListModel!
    
    override func setUp() {
        database = MockDatabase()
        model = BaseTransactionListModel(database: database)
        super.setUp()
    }
    
    override func tearDown() {
        database = nil
        model = nil
        super.tearDown()
    }
    
    //не тестируется выборка по категории/типу так как это ответственность Database, тестируется там, модель - посредник
    func testGetTransactions() {
        database.transactions = [DefaultTransaction()]
        database.categories = [DefaultCategory()]//добавить категорию, чтобы в модели прошла хоть одна итерация
        
        let fetchedTransactionsCount = model.getTransactionList(for: Calendar.current.dateInterval(of: .era, for: Date())!, type: .expense).count
        
        XCTAssertEqual(fetchedTransactionsCount, 1)
    }

    func testGetTransactionByDays() {
        database.categories = [DefaultCategory()]//добавить категорию, чтобы в модели прошла хоть одна итерация
        let transaction1 = DefaultTransaction(date: Date().addingTimeInterval(-86400), information: "1")
        let transaction2 = DefaultTransaction(date: Date(), information: "2")
        let transaction3 = DefaultTransaction(date: Date().addingTimeInterval(86400), information: "3")
        database.transactions = [transaction1, transaction2, transaction3]
        let expected1 = TransactionListItem(interval: Calendar.current.dateInterval(of: .day, for: Date().addingTimeInterval(-86400))!, items: [transaction1])
        let expected2 = TransactionListItem(interval: Calendar.current.dateInterval(of: .day, for: Date())!, items: [transaction2])
        let expected3 = TransactionListItem(interval: Calendar.current.dateInterval(of: .day, for: Date().addingTimeInterval(86400))!, items: [transaction3])
        let expectedResult = [expected3, expected2, expected1]
        
        let result = model.getTransactionList(for: Calendar.current.dateInterval(of: .era, for: Date())!, type: .expense)
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func testGetCategory() {
        let category = DefaultCategory()
        database.categories = [category]
        
        let fetchedCategory = model.getCategory(id: category.id) as? DefaultCategory
        
        XCTAssertEqual(fetchedCategory, category)
    }
    
    func testGetIcon() {
        let icon = DefaultIcon(id: "icon")
        database.icons = [icon]
        
        let fetchedIcon = model.getIcon(iconId: "icon")
        
        XCTAssertNotNil(fetchedIcon)
    }
    
}

fileprivate class MockDatabase: DatabaseFacade {
    
    var moneyOffset: Double = 0.0
    var transactions: [any FinanceApp.IdentifiableTransaction] = []
    var categories: [any FinanceApp.IdentifiableCategory] = []
    var icons: [any Icon] = []
    
    func getTransactions(interval: DateInterval?, category: any FinanceApp.IdentifiableCategory) -> [any FinanceApp.IdentifiableTransaction] {
        return transactions
    }
    
    func getCategories(of type: FinanceApp.CategoryType) -> [any FinanceApp.IdentifiableCategory] {
        return categories
    }
    
    func getCategory(id: UUID) -> (any FinanceApp.IdentifiableCategory)? {
        categories.first { $0.id == id }
    }
    
    func getIcons() -> [any FinanceApp.Icon] {
        return icons
    }
    
    func getIcon(id: String) -> (any FinanceApp.Icon)? {
        return icons.first { $0.id == id }
    }
    
    func totalAmount(_ type: FinanceApp.CategoryType, for interval: DateInterval?) -> Double { 0 }
    func categoriesSummary(_ type: FinanceApp.CategoryType, for interval: DateInterval?) -> [FinanceApp.TransactionCategoryMeta] { [] }
    func getTransaction(id: UUID) -> (any FinanceApp.IdentifiableTransaction)? { nil }
    func getAllTransactions(interval: DateInterval?) -> [any FinanceApp.IdentifiableTransaction] { [] }
    func addTransaction(_ transaction: any FinanceApp.Transaction) -> (any FinanceApp.IdentifiableTransaction)? { nil }
    func updateTransaction(id: UUID, with newTransaction: any FinanceApp.Transaction) {}
    func removeTransaction(id: UUID) {}
    func getAllCategories() -> [any FinanceApp.IdentifiableCategory] { [] }
    func addCategory(_ category: any FinanceApp.Category) -> (any FinanceApp.IdentifiableCategory)? { nil }
    func updateCategory(id: UUID, with newCategory: any FinanceApp.Category) {}
    func removeCategory(id: UUID) {}
    func getIconsWithKind() -> [FinanceApp.IconKind : [any FinanceApp.Icon]] { [:] }
    func getColors() -> [UIColor] { [] }
    
    
}

