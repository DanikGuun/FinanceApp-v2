
import XCTest
@testable import FinanceApp

final class EditTransactionModelTests: XCTestCase {
    
    fileprivate var transactions: MockTransactionDatabase!
    fileprivate var categories: MockCategoryDatabase!
    fileprivate var iconProvider: MockIconProvider!
    var model: EditTransactionModel!
    
    let editingId = UUID()
    
    override func setUp() {
        transactions = MockTransactionDatabase()
        categories = MockCategoryDatabase()
        iconProvider = MockIconProvider()
        model = EditTransactionModel(editingTransactionId: editingId, transactionDatabase: transactions, categoryDatabase: categories, iconProvider: iconProvider)
        super.setUp()
    }
    
    override func tearDown() {
        transactions = nil
        categories = nil
        iconProvider = nil
        model = nil
        super.tearDown()
    }
    
    func testEditPerform() {
        let transaction = DefaultTransaction(id: editingId, amount: 1000)
        transactions.transactions = [transaction]
        let newTransaction = DefaultTransaction(amount: 1500)
        
        model.perform(transaction: newTransaction)
        
        let fetchedTransaction = transactions.transactions.first! as? DefaultTransaction
        XCTAssertEqual(fetchedTransaction?.amount, 1500)
    }
    
    func testFetchCategories() {
        let categoryList: [DefaultCategory] = [DefaultCategory(id: UUID()), DefaultCategory(id: UUID()), DefaultCategory(id: UUID(), type: .income), DefaultCategory(id: UUID()), DefaultCategory(id: UUID()), DefaultCategory(id: UUID()), DefaultCategory(id: UUID()), DefaultCategory(id: UUID())]
        categories.categories = categoryList
        
        let fetched = model.getCategories(of: .expense).map { $0 as! DefaultCategory }
        let expected = Array(categoryList.filter({ $0.type == .expense })[0..<5])
        
        XCTAssertEqual(fetched, expected)
    }
    
    func testGetCategory() {
        let category = DefaultCategory()
        categories.categories = [category]
        
        let fetchedCategory = model.getCategory(id: category.id) as? DefaultCategory
        
        XCTAssertEqual(fetchedCategory, category)
    }
    
    func testGetIcon() {
        iconProvider.icons = [DefaultIcon(id: "icon")]
        
        let icon = model.getIcon(iconId: "icon")
        
        XCTAssertNotNil(icon)
    }
    
}

fileprivate class MockTransactionDatabase: TransactionDatabase {
    
    var transactions: [(any FinanceApp.IdentifiableTransaction)] = []
    
    var moneyOffset: Double = 0
    
    func getTransaction(id: UUID) -> (any FinanceApp.IdentifiableTransaction)? {
        return transactions.first { $0.id == id }
    }
    
    func getAllTransactions(interval: DateInterval?) -> [any FinanceApp.IdentifiableTransaction] { [] }
    
    func getTransactions(interval: DateInterval?, category: any FinanceApp.IdentifiableCategory) -> [any FinanceApp.IdentifiableTransaction] { [] }
    
    func addTransaction(_ transaction: any FinanceApp.Transaction) -> (any FinanceApp.IdentifiableTransaction)? {
        transactions.append(transaction as! any IdentifiableTransaction)
        return nil
    }
    
    func updateTransaction(id: UUID, with newTransaction: any FinanceApp.Transaction) {
        let index = transactions.firstIndex { $0.id == id }!
        transactions[index] = newTransaction as! any IdentifiableTransaction
    }
    
    func removeTransaction(id: UUID) {}
    
}

fileprivate class MockCategoryDatabase: CategoryDatabase {
    
    var categories: [(any FinanceApp.IdentifiableCategory)] = []
    
    func getCategory(id: UUID) -> (any FinanceApp.IdentifiableCategory)? {
        return categories.first { $0.id == id }
    }
    
    func getAllCategories() -> [any FinanceApp.IdentifiableCategory] {
        return categories
    }
    
    func getCategories(of type: FinanceApp.CategoryType) -> [any FinanceApp.IdentifiableCategory] {
        return categories.filter { $0.type == type }
    }
    
    func addCategory(_ category: any FinanceApp.Category) -> (any FinanceApp.IdentifiableCategory)? {
        categories.append(category as! any IdentifiableCategory)
        return nil
    }
    
    func updateCategory(id: UUID, with newCategory: any FinanceApp.Category) {}
    
    func removeCategory(id: UUID) {}
    
    
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
