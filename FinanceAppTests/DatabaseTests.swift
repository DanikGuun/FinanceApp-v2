
import XCTest
@testable import FinanceApp

//интеграционный тест для проверки взаимодействия частей БД
final class DatabaseTests: XCTestCase {
    
    fileprivate var database: Database!
    
    override func setUpWithError() throws {
        
        let categoryDB = CategoryDatabaseFactory.getTestDatabase()
        let transactionDB = TransactionDatabaseFactory.getTestDatabase()
        
        let iconProvider1 = MockIconProvider(icons: [MockIcon(id: "id1", image: UIImage(), kind: .base), MockIcon(id: "id2", image: UIImage(), kind: .base)])
        let iconProvider2 = MockIconProvider(icons: [MockIcon(id: "id3", image: UIImage(), kind: .base), MockIcon(id: "id4", image: UIImage(), kind: .base)])
        let iconProvider = CompositeIconProvider(iconProviders: [iconProvider1, iconProvider2])
        
        let colorProvider1 = MockColorProvider(colors: [.red, .blue])
        let colorProvider2 = MockColorProvider(colors: [.green, .yellow])
        let colorProvider = CompositeColorProvider(colorProviders: [colorProvider1, colorProvider2])
        
        self.database =  Database(transactionsDB: transactionDB, categoryDB: categoryDB, iconProvider: iconProvider, colorProvider: colorProvider)
        
        try super.setUpWithError()
    }
    
    override func tearDown() {
        super.tearDown()
        self.database = nil
    }
    
    //MARK: - Category Testing
    func testCategorySaveFetchDelete(){
        
        let database = self.database!
        
        let categoryConf = DefaultCategory(name: "name", type: .expense, iconId: "", color: .cyan)
        let category = database.addCategory(categoryConf)
        
        XCTAssertNotNil(category)
        
        let fetchedCategory = database.getAllCategories().first
        XCTAssertNotNil(fetchedCategory)
        XCTAssertEqual(fetchedCategory!.name, categoryConf.name)
        
        database.removeCategory(id: fetchedCategory!.id)
        
        let emptyCategory = database.getAllCategories().first
        XCTAssertNil(emptyCategory)
        
    }
    
    func testCategoryUpdate(){
        let database = self.database!
        
        let categoryConf = DefaultCategory(name: "Name", type: .expense, iconId: "id", color: .blue)
        let category = database.addCategory(categoryConf)
        XCTAssertNotNil(category)
        
        let newCategoryConf = DefaultCategory(name: "NewName", type: .income, iconId: "newId", color: .red)
        database.updateCategory(id: category!.id, with: newCategoryConf)
        
        let newCategory = database.getCategory(id: category!.id)
        XCTAssertNotNil(newCategory)
        XCTAssertEqual(newCategory!.name, "NewName")
        XCTAssertEqual(newCategory!.type, .income)
        XCTAssertEqual(newCategory!.iconId, "newId")
        XCTAssertEqual(newCategory!.color, .red)
    }
    
    func testCategoryFetchWithInvalidID(){
        
        let database = self.database!
        let category = database.getCategory(id: UUID())
        XCTAssertNil(category)
        
    }
    
    func testCategoryFetchByID(){
        
        let database = self.database!
        
        let expenseCategoryConf = DefaultCategory(name: "Expense", type: .expense, iconId: "", color: .black)
        let expenseCategoryID = database.addCategory(expenseCategoryConf)?.id
        
        XCTAssertNotNil(expenseCategoryID)
        XCTAssertNotNil(database.getCategory(id: expenseCategoryID!))
        
        XCTAssertEqual(database.getCategory(id: expenseCategoryID!)!.type, .expense)
        
        XCTAssertEqual(database.getCategories(of: .expense).count, 1)
    }
    
    func testCategoryFetchByType(){
        
        let database = self.database!
        
        let expenseCategoryConf = DefaultCategory(name: "Expence", type: .expense, iconId: "", color: .red)
        database.addCategory(expenseCategoryConf)
        
        let incomeCategoryConf = DefaultCategory(name: "Income", type: .income, iconId: "", color: .red)
        database.addCategory(incomeCategoryConf)
        
        let fetchedExpenseCategory = database.getCategories(of: .expense).first
        XCTAssertNotNil(fetchedExpenseCategory)
        XCTAssertEqual(fetchedExpenseCategory!.name, "Expence")
        XCTAssertEqual(fetchedExpenseCategory!.type, .expense)
        XCTAssertEqual(fetchedExpenseCategory!.iconId, "")
        XCTAssertEqual(fetchedExpenseCategory!.color, .red)
        
        let fetchedIncomeCategory = database.getCategories(of: .income).first
        XCTAssertNotNil(fetchedIncomeCategory)
        XCTAssertEqual(fetchedIncomeCategory!.name, "Income")
        XCTAssertEqual(fetchedIncomeCategory!.type, .income)
        XCTAssertEqual(fetchedIncomeCategory!.iconId, "")
        XCTAssertEqual(fetchedIncomeCategory!.color, .red)
        
    }
    
    //MARK: - Transaction Testing
    
    func testTransactionSaveFetchDelete() {
        
        let database = self.database!
        
        let transactionConf = DefaultTransaction(categoryID: UUID(), amount: 100, date: Date(timeIntervalSince1970: 10))
        let transaction = database.addTransaction(transactionConf)
        
        XCTAssertNotNil(transaction)
        
        let fetchedTransaction = database.getAllTransactions(interval: nil).first
        XCTAssertNotNil(fetchedTransaction)
        XCTAssertEqual(fetchedTransaction!.amount, transactionConf.amount)
        
        database.removeTransaction(id: transaction!.id)
        
        let emptyTransaction = database.getAllTransactions(interval: nil).first
        XCTAssertNil(emptyTransaction)
        
    }
    
    func testTransactionUpdate() {
        
        let dataBase = self.database!
        
        let transactionConf = DefaultTransaction(categoryID: UUID(), amount: 0, date: Date(timeIntervalSince1970: 10))
        var transaction = dataBase.addTransaction(transactionConf)
        
        XCTAssertNotNil(transaction)
        
        let neeTransactionConf = DefaultTransaction(categoryID: UUID(), amount: 10, date: Date(timeIntervalSince1970: 1000))
        dataBase.updateTransaction(id: transaction!.id, with: neeTransactionConf)
        
        transaction = dataBase.getTransaction(id: transaction!.id)
        
        XCTAssertEqual(transaction!.categoryID, neeTransactionConf.categoryID)
        XCTAssertEqual(transaction!.amount, neeTransactionConf.amount)
        XCTAssertEqual(transaction!.date, neeTransactionConf.date)
        
    }
    
    func testTransactionFetchWithInvalidID() {
        
        let database = self.database!
        let transaction = database.getTransaction(id: UUID())
        XCTAssertNil(transaction)
        
    }
    
    //MARK: Transaction With interval
    func fetchByDateIntervalTest(taskDate: Double, start: Double, end: Double, result: Bool) {
        
        let database = self.database!
        
        let transactionConf = DefaultTransaction(categoryID: UUID(), amount: 10, date: Date(timeIntervalSince1970: taskDate))
        database.addTransaction(transactionConf)
        
        let startDate = Date(timeIntervalSince1970: start)
        let endDate = Date(timeIntervalSince1970: end)
        let dateInterval = DateInterval(start: startDate, end: endDate)
        
        let count = database.getAllTransactions(interval: dateInterval).count
        
        XCTAssertEqual(count, result ? 1 : 0)
        
    }
    
    func testTransactionWithDateIntervalInBoundsSelection() {
        fetchByDateIntervalTest(taskDate: 50, start: 0, end: 100, result: true)
    }
    
    func testTransactionWithDateIntervalOutOfBounds() {
        fetchByDateIntervalTest(taskDate: 50, start: 100, end: 200, result: false)
    }
    
    func testTransactionWithDateIntervalLeftBound() {
        fetchByDateIntervalTest(taskDate: 10, start: 10, end: 50, result: true)
    }
    
    func testTransactionWithDateIntervalRightBound() {
        fetchByDateIntervalTest(taskDate: 90, start: 0, end: 90, result: true)
    }
    
    //MARK: - Categories + Transaction
    
    func testFetchCategoryFromTransaction() {
        
        let database = self.database!
        
        let category = database.addCategory(DefaultCategory(name: "Expense", type: .expense, iconId: "", color: .red))
        XCTAssertNotNil(category)
        
        let transaction = database.addTransaction(DefaultTransaction(categoryID: category!.id, amount: 100, date: Date(timeIntervalSince1970: 0)))
        XCTAssertNotNil(transaction)
        
        let fetchedCategory = database.getCategory(id: transaction!.categoryID)
        
        XCTAssertNotNil(fetchedCategory)
        XCTAssertEqual(category!.id, fetchedCategory!.id)
        XCTAssertEqual(category!.name, fetchedCategory!.name)
        XCTAssertEqual(category!.type, fetchedCategory!.type)
        XCTAssertEqual(category!.color, fetchedCategory!.color)
        XCTAssertEqual(category!.iconId, fetchedCategory!.iconId)
        
    }
    
    func testFetchTransactionsByCategory() {
        
        let database = self.database!
        
        let categoryConf = DefaultCategory(name: "Category", type: .expense, iconId: "", color: .cyan)
        let category = database.addCategory(categoryConf)
        XCTAssertNotNil(category)
        
        let transactionWithCorrectCategoryConf = DefaultTransaction(categoryID: category!.id, amount: 10, date: Date(timeIntervalSince1970: 10))
        let transactionWithIncorrectCategoryConf = DefaultTransaction(categoryID: UUID(), amount: 20, date: Date(timeIntervalSince1970: 20))
        database.addTransaction(transactionWithCorrectCategoryConf)
        database.addTransaction(transactionWithIncorrectCategoryConf)
        
        let transactions = database.getTransactions(interval: nil, category: category!)
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transactions.first!.categoryID, category!.id)
        XCTAssertEqual(transactions.first!.amount, 10)
        
    }
    
    func databaseForSummaryTest() -> Database {
        let database = self.database!
        
        let expenseCategory1 = database.addCategory(DefaultCategory(name: "Expense", type: .expense, iconId: "", color: .cyan))
        database.addTransaction(DefaultTransaction(categoryID: expenseCategory1!.id, amount: 1, date: Date(timeIntervalSince1970: 0)))
        database.addTransaction(DefaultTransaction(categoryID: expenseCategory1!.id, amount: 10, date: Date(timeIntervalSince1970: 50)))
        database.addTransaction(DefaultTransaction(categoryID: expenseCategory1!.id, amount: 100, date: Date(timeIntervalSince1970: 100)))
        database.addTransaction(DefaultTransaction(categoryID: expenseCategory1!.id, amount: 1000, date: Date(timeIntervalSince1970: 150)))

        let expenseCategory2 = database.addCategory(DefaultCategory(name: "Expense2", type: .expense, iconId: "", color: .cyan))
        database.addTransaction(DefaultTransaction(categoryID: expenseCategory2!.id, amount: 4, date: Date(timeIntervalSince1970: 0)))
        database.addTransaction(DefaultTransaction(categoryID: expenseCategory2!.id, amount: 40, date: Date(timeIntervalSince1970: 50)))
        database.addTransaction(DefaultTransaction(categoryID: expenseCategory2!.id, amount: 400, date: Date(timeIntervalSince1970: 100)))
        database.addTransaction(DefaultTransaction(categoryID: expenseCategory2!.id, amount: 4000, date: Date(timeIntervalSince1970: 150)))
        
        let incomeCategory = database.addCategory(DefaultCategory(name: "Income", type: .income, iconId: "", color: .cyan))
        database.addTransaction(DefaultTransaction(categoryID: incomeCategory!.id, amount: 1000000000, date: Date(timeIntervalSince1970: 100)))
        
        return database
    }
    
    func testTotalAmountWithNormalData() {
        
        let database = databaseForSummaryTest()
        
        let start = Date(timeIntervalSince1970: 50)
        let end = Date(timeIntervalSince1970: 150)
        let interval = DateInterval(start: start, end: end)
        
        let amount = database.totalAmount(.expense, for: interval)
        XCTAssertEqual(amount, 5550)
        
    }
    
    func testTotalAmountWithNoData() {
        
        let database = self.database!
        
        let amount = database.totalAmount(.expense, for: nil)
        
        XCTAssertEqual(amount, 0)
    }
    
    func testCategoriesSummaryWithNormalData() {
        
        let database = databaseForSummaryTest()
        
        let start = Date(timeIntervalSince1970: 50)
        let end = Date(timeIntervalSince1970: 150)
        let interval = DateInterval(start: start, end: end)
        
        let summary = database.categoriesSummary(.expense, for: interval).first( where: { $0.name == "Expense"} )
        XCTAssertNotNil(summary)
        XCTAssertEqual(summary!.amount, 1110)
        XCTAssertEqual(summary!.percentage, 20) // 1110/5550 (2-4 транзакции в Expense категориях)
        
    }
    
    func testCategorySummaryWithNoData() {
        
        let database = self.database!
        let summary = database.categoriesSummary(.expense, for: nil)
        XCTAssertEqual(summary.count, 0)
        
    }
    
    //MARK: - Icons
    func testIconsFetch() {
        
        let database = self.database!
        let icons = database.getIcons()
        
        XCTAssertEqual(icons.count, 4)
        XCTAssert(icons.contains { $0.id == "id1" } )
        XCTAssert(icons.contains { $0.id == "id2" } )
        XCTAssert(icons.contains { $0.id == "id3" } )
        XCTAssert(icons.contains { $0.id == "id4" } )
        
    }
    
    func testIconFetchByID() {
        
        let database = self.database!
        
        XCTAssertNotNil(database.getIcon(id: "id1"))
        XCTAssertNotNil(database.getIcon(id: "id2"))
        XCTAssertNotNil(database.getIcon(id: "id3"))
        XCTAssertNotNil(database.getIcon(id: "id4"))
        
    }
    
    func testIconFetchingWithType() {
        
        let database = self.database!
        let icons = database.getIconsWithKind()
        
        XCTAssertNotNil(icons[.base])
        XCTAssertEqual(icons[.base]!.count, 4)
        XCTAssert(icons[.base]!.contains { $0.id == "id1" } )
        XCTAssert(icons[.base]!.contains { $0.id == "id2" } )
        XCTAssert(icons[.base]!.contains { $0.id == "id3" } )
        XCTAssert(icons[.base]!.contains { $0.id == "id4" } )
        
    }
    
    //MARK: Colors
    
    func testColorsFetching() {
        
        let database = self.database!
        let colors = database.getColors()
        
        XCTAssertEqual(colors.count, 4)
        XCTAssert(colors.contains { $0 == .red } )
        XCTAssert(colors.contains { $0 == .green } )
        XCTAssert(colors.contains { $0 == .yellow } )
        XCTAssert(colors.contains { $0 == .blue } )
        
        
    }
    
}

fileprivate class MockIconProvider: IconProvider {
    
    var icons: [MockIcon] = []
    
    init(icons: [MockIcon]) {
        self.icons = icons
    }
    
    func getIcons() -> [any FinanceApp.Icon] {
        return icons
    }
    
    func getIcon(id: String) -> (any FinanceApp.Icon)? {
        return icons.first(where: { $0.id == id })
    }
    
    func getIconsWithKind() -> [FinanceApp.IconKind : [any FinanceApp.Icon]] {
        
        var dict: [FinanceApp.IconKind : [any FinanceApp.Icon]] = [:]
        icons.forEach {
            dict[$0.kind, default: []].append($0)
        }
        
        return dict
        
    }
    
}

struct MockIcon: Icon {
    
    var id: String
    var image: UIImage
    var kind: FinanceApp.IconKind
    
}

fileprivate class MockColorProvider: ColorProvider {
    
    var colors: [UIColor] = []
    
    init(colors: [UIColor]){
        self.colors = colors
    }
    
    func getColors() -> [UIColor] {
        return colors
    }
    
}
