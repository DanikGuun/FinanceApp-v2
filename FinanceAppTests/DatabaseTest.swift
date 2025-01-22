
import XCTest
@testable import FinanceApp

//интеграционный тест для проверки взаимодействия частей БД
final class DatabaseTest: XCTestCase {
    
    var database: Database!
    
    override func setUpWithError() throws {
        
        let categoryDB = TransactionCategoryDatabaseFactory.getTestDatabase()
        let transactionDB = TransactionDatabaseFactory.getTestDatabase()
        
        let iconProvider1 = MockIconProvider(icons: [MockIcon(id: "id1", image: UIImage(), kind: .base),
                                                MockIcon(id: "id2", image: UIImage(), kind: .base)])
        let iconProvider2 = MockIconProvider(icons: [MockIcon(id: "id3", image: UIImage(), kind: .base),
                                                MockIcon(id: "id4", image: UIImage(), kind: .base)])
        
        let colorProvider1 = MockColorProvider(colors: [.red, .blue])
        let colorProvider2 = MockColorProvider(colors: [.green, .yellow])
        
        self.database =  Database(transactionsDB: transactionDB, categoryDB: categoryDB, iconProviders: [iconProvider1, iconProvider2], colorProviders: [colorProvider1, colorProvider2])
        
        try super.setUpWithError()
    }
    
    override func tearDown() {
        super.tearDown()
        self.database = nil
    }
    
    //MARK: - Category Testing
    func testCategorySaveRetriveDelete(){
        
        let database = self.database!
        
        let categoryInfo = TransactionCategoryInfo(name: "name", type: .expense, iconID: "", color: .cyan)
        let category = database.add(categoryInfo)
        
        XCTAssertNotNil(category)
        
        let categoryFromDB = database.allCategories().first
        XCTAssertNotNil(categoryFromDB)
        XCTAssertEqual(categoryFromDB!.name, categoryInfo.name)
        
        database.remove(categoryFromDB!)
        
        let emptyCategory = database.allCategories().first
        XCTAssertNil(emptyCategory)
        
    }
    
    func testCategoryUpdate(){
        let database = self.database!
        
        let categoryInfo = TransactionCategoryInfo(name: "Name", type: .expense, iconID: "id", color: .blue)
        let category = database.add(categoryInfo)
        XCTAssertNotNil(category)
        
        let newCategoryInfo = TransactionCategoryInfo(name: "NewName", type: .income, iconID: "newId", color: .red)
        database.update(category!, with: newCategoryInfo)
        
        let newCategory = database.category(id: category!.id)
        XCTAssertNotNil(newCategory)
        XCTAssertEqual(newCategory!.name, "NewName")
        XCTAssertEqual(newCategory!.type, .income)
        XCTAssertEqual(newCategory!.iconID, "newId")
        XCTAssertEqual(newCategory!.color, .red)
    }
    
    func testCategoryFetchWithInvalidID(){
        
        let database = self.database!
        let category = database.category(id: UUID())
        XCTAssertNil(category)
        
    }
    
    func testCategoryFetchingByID(){
        
        let database = self.database!
        
        let expenseCategoryInfo = TransactionCategoryInfo(name: "Expense", type: .expense, iconID: "", color: .black)
        let expenseID = database.add(expenseCategoryInfo)?.id
        
        XCTAssertNotNil(expenseID)
        XCTAssertNotNil(database.category(id: expenseID!))
        
        XCTAssertEqual(database.category(id: expenseID!)!.type, .expense)
        
        XCTAssertEqual(database.categories(of: .expense).count, 1)
    }
    
    func testCategoryFetchingByType(){
        
        let database = self.database!
        
        let expenseCategoryInfo = TransactionCategoryInfo(name: "Expence", type: .expense, iconID: "", color: .red)
        database.add(expenseCategoryInfo)
        
        let incomeCategoryInfo = TransactionCategoryInfo(name: "Income", type: .income, iconID: "", color: .red)
        database.add(incomeCategoryInfo)
        
        let fetchedExpenseCategory = database.categories(of: .expense).first
        XCTAssertNotNil(fetchedExpenseCategory)
        XCTAssertEqual(fetchedExpenseCategory!.name, "Expence")
        XCTAssertEqual(fetchedExpenseCategory!.type, .expense)
        XCTAssertEqual(fetchedExpenseCategory!.iconID, "")
        XCTAssertEqual(fetchedExpenseCategory!.color, .red)
        
        let fetchedIncomeCategory = database.categories(of: .income).first
        XCTAssertNotNil(fetchedIncomeCategory)
        XCTAssertEqual(fetchedIncomeCategory!.name, "Income")
        XCTAssertEqual(fetchedIncomeCategory!.type, .income)
        XCTAssertEqual(fetchedIncomeCategory!.iconID, "")
        XCTAssertEqual(fetchedIncomeCategory!.color, .red)
        
    }
    
    //MARK: - Transaction Testing
    
    func testTransactionSaveRetriveDelete() {
        
        let database = self.database!
        
        let transactionInfo = TransactionInfo(categoryID: UUID(), amount: 100, date: Date(timeIntervalSince1970: 10))
        let transaction = database.add(transactionInfo)
        
        XCTAssertNotNil(transaction)
        
        let transactionFromDB = database.allTransactions(period: nil).first
        XCTAssertNotNil(transactionFromDB)
        XCTAssertEqual(transactionFromDB!.amount, transactionInfo.amount)
        
        database.remove(transaction!)
        
        let emptyTransaction = database.allTransactions(period: nil).first
        XCTAssertNil(emptyTransaction)
        
    }
    
    func testTransactionUpdate() {
        
        let dataBase = self.database!
        
        let transactionInfo = TransactionInfo(categoryID: UUID(), amount: 0, date: Date(timeIntervalSince1970: 10))
        var transaction = dataBase.add(transactionInfo)
        
        XCTAssertNotNil(transaction)
        
        let newInfo = TransactionInfo(categoryID: UUID(), amount: 10, date: Date(timeIntervalSince1970: 1000))
        dataBase.update(transaction!, with: newInfo)
        
        transaction = dataBase.transaction(id: transaction!.id)
        
        XCTAssertEqual(transaction!.categoryID, newInfo.categoryID)
        XCTAssertEqual(transaction!.amount, newInfo.amount)
        XCTAssertEqual(transaction!.date, newInfo.date)
        
    }
    
    func testTransactionRetriveWithInvalidID() {
        
        let database = self.database!
        let transaction = database.transaction(id: UUID())
        XCTAssertNil(transaction)
        
    }
    
    //MARK: Transaction With interval
    func dateIntervalTest(taskDate: Double, start: Double, end: Double, result: Bool){
        
        let database = self.database!
        
        let transactionInfo = TransactionInfo(categoryID: UUID(), amount: 10, date: Date(timeIntervalSince1970: taskDate))
        database.add(transactionInfo)
        
        let startDate = Date(timeIntervalSince1970: start)
        let endDate = Date(timeIntervalSince1970: end)
        let dateInterval = DateInterval(start: startDate, end: endDate)
        
        let count = database.allTransactions(period: dateInterval).count
        
        XCTAssertEqual(count, result ? 1 : 0)
        
    }
    
    func testTransactionWithDateIntervalInBoundsSelection(){
        dateIntervalTest(taskDate: 50, start: 0, end: 100, result: true)
    }
    
    func testTransactionWithDateIntervalOutOfBoundsSelection(){
        dateIntervalTest(taskDate: 50, start: 100, end: 200, result: false)
    }
    
    func testTransactionWithDateIntervalLeftBoundSelection(){
        dateIntervalTest(taskDate: 10, start: 10, end: 50, result: true)
    }
    
    func testTransactionWithDateIntervalRightBoundSelection(){
        dateIntervalTest(taskDate: 90, start: 0, end: 90, result: true)
    }
    
    //MARK: - Categories + Transaction
    
    func testFetchCategoryFromTransaction(){
        
        let database = self.database!
        
        let category = database.add(TransactionCategoryInfo(name: "Expense", type: .expense, iconID: "", color: .red))
        XCTAssertNotNil(category)
        
        let transaction = database.add(TransactionInfo(categoryID: category!.id, amount: 100, date: Date(timeIntervalSince1970: 0)))
        XCTAssertNotNil(transaction)
        
        let fetchedCategory = database.category(id: transaction!.categoryID)
        
        XCTAssertNotNil(fetchedCategory)
        XCTAssertEqual(category!.id, fetchedCategory!.id)
        XCTAssertEqual(category!.name, fetchedCategory!.name)
        XCTAssertEqual(category!.type, fetchedCategory!.type)
        XCTAssertEqual(category!.color, fetchedCategory!.color)
        XCTAssertEqual(category!.iconID, fetchedCategory!.iconID)
        
    }
    
    func testFetchTransactionsByCategory(){
        
        let database = self.database!
        
        let categoryInfo = TransactionCategoryInfo(name: "Category", type: .expense, iconID: "", color: .cyan)
        let category = database.add(categoryInfo)
        XCTAssertNotNil(category)
        
        let transactionInfo = TransactionInfo(categoryID: category!.id, amount: 10, date: Date(timeIntervalSince1970: 10))
        let transactionInfo2 = TransactionInfo(categoryID: UUID(), amount: 20, date: Date(timeIntervalSince1970: 20))
        database.add(transactionInfo)
        database.add(transactionInfo2)
        
        let transactions = database.transactions(period: nil, category: category!)
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transactions.first!.categoryID, category!.id)
        XCTAssertEqual(transactions.first!.amount, 10)
        
    }
    
    func databaseForSummaryTest() -> Database{
        let database = self.database!
        
        let expenseCategory1 = database.add(TransactionCategoryInfo(name: "Expense", type: .expense, iconID: "", color: .cyan))
        database.add(TransactionInfo(categoryID: expenseCategory1!.id, amount: 1, date: Date(timeIntervalSince1970: 0)))
        database.add(TransactionInfo(categoryID: expenseCategory1!.id, amount: 10, date: Date(timeIntervalSince1970: 50)))
        database.add(TransactionInfo(categoryID: expenseCategory1!.id, amount: 100, date: Date(timeIntervalSince1970: 100)))
        database.add(TransactionInfo(categoryID: expenseCategory1!.id, amount: 1000, date: Date(timeIntervalSince1970: 150)))

        let expenseCategory2 = database.add(TransactionCategoryInfo(name: "Expense2", type: .expense, iconID: "", color: .cyan))
        database.add(TransactionInfo(categoryID: expenseCategory2!.id, amount: 4, date: Date(timeIntervalSince1970: 0)))
        database.add(TransactionInfo(categoryID: expenseCategory2!.id, amount: 40, date: Date(timeIntervalSince1970: 50)))
        database.add(TransactionInfo(categoryID: expenseCategory2!.id, amount: 400, date: Date(timeIntervalSince1970: 100)))
        database.add(TransactionInfo(categoryID: expenseCategory2!.id, amount: 4000, date: Date(timeIntervalSince1970: 150)))
        
        let incomeCategory = database.add(TransactionCategoryInfo(name: "Income", type: .income, iconID: "", color: .cyan))
        database.add(TransactionInfo(categoryID: incomeCategory!.id, amount: 1000000000, date: Date(timeIntervalSince1970: 100)))
        
        return database
    }
    
    func testTotalAmountWithNormalData(){
        
        let database = databaseForSummaryTest()
        
        let start = Date(timeIntervalSince1970: 50)
        let end = Date(timeIntervalSince1970: 150)
        let interval = DateInterval(start: start, end: end)
        
        let amount = database.totalAmount(.expense, for: interval)
        XCTAssertEqual(amount, 5550)
        
    }
    
    func testTotalAmountWithNoData(){
        
        let database = self.database!
        
        let amount = database.totalAmount(.expense, for: nil)
        
        XCTAssertEqual(amount, 0)
    }
    
    func testCategoriesSummaryWithNormalData(){
        
        let database = databaseForSummaryTest()
        
        let start = Date(timeIntervalSince1970: 50)
        let end = Date(timeIntervalSince1970: 150)
        let interval = DateInterval(start: start, end: end)
        
        let summary = database.categoriesSummary(.expense, for: interval).first( where: { $0.name == "Expense"} )
        XCTAssertNotNil(summary)
        XCTAssertEqual(summary!.amount, 1110)
        XCTAssertEqual(summary!.percentage, 20) // 1110/5550 (2-4 транзакции в Expense категориях)
        
    }
    
    func testCategorySummaryWithNoData(){
        
        let database = self.database!
        let summary = database.categoriesSummary(.expense, for: nil)
        XCTAssertEqual(summary.count, 0)
        
    }
    
    //MARK: - Icons
    func testIconsFetching(){
        
        let database = self.database!
        let icons = database.getIcons()
        
        XCTAssertEqual(icons.count, 4)
        XCTAssert(icons.contains { $0.id == "id1" } )
        XCTAssert(icons.contains { $0.id == "id2" } )
        XCTAssert(icons.contains { $0.id == "id3" } )
        XCTAssert(icons.contains { $0.id == "id4" } )
        
    }
    
    func testIconFetchingByID(){
        
        let database = self.database!
        
        XCTAssertNotNil(database.getIcon(id: "id1"))
        XCTAssertNotNil(database.getIcon(id: "id2"))
        XCTAssertNotNil(database.getIcon(id: "id3"))
        XCTAssertNotNil(database.getIcon(id: "id4"))
        
    }
    
    func testIconFetchingWithType(){
        
        let database = self.database!
        let icons = database.getIconsWithType()
        
        XCTAssertNotNil(icons[.base])
        XCTAssertEqual(icons[.base]!.count, 4)
        XCTAssert(icons[.base]!.contains { $0.id == "id1" } )
        XCTAssert(icons[.base]!.contains { $0.id == "id2" } )
        XCTAssert(icons[.base]!.contains { $0.id == "id3" } )
        XCTAssert(icons[.base]!.contains { $0.id == "id4" } )
        
    }
    
    //MARK: Colors
    
    func testColorsFetching(){
        
        let database = self.database!
        let colors = database.getColors()
        
        XCTAssertEqual(colors.count, 4)
        XCTAssert(colors.contains { $0 == .red } )
        XCTAssert(colors.contains { $0 == .green } )
        XCTAssert(colors.contains { $0 == .yellow } )
        XCTAssert(colors.contains { $0 == .blue } )
        
        
    }
    
}

class MockIconProvider: TransactionCategoryIconProvider{
    
    var icons: [MockIcon] = []
    
    init(icons: [MockIcon]) {
        self.icons = icons
    }
    
    func getIcons() -> [any FinanceApp.TransactionCategoryIcon] {
        return icons
    }
    
    func getIcon(id: String) -> (any FinanceApp.TransactionCategoryIcon)? {
        return icons.first(where: { $0.id == id })
    }
    
    func getIconsWithType() -> [FinanceApp.TransactionCategoryIconKind : [any FinanceApp.TransactionCategoryIcon]] {
        
        var dict: [FinanceApp.TransactionCategoryIconKind : [any FinanceApp.TransactionCategoryIcon]] = [:]
        icons.forEach {
            dict[$0.kind, default: []].append($0)
        }
        
        return dict
        
    }
    
}

struct MockIcon: TransactionCategoryIcon{
    
    var id: String
    var image: UIImage
    var kind: FinanceApp.TransactionCategoryIconKind
    
}

class MockColorProvider: TransactionCategoryColorsProvider{
    
    var colors: [UIColor] = []
    
    init(colors: [UIColor]){
        self.colors = colors
    }
    
    func getColors() -> [UIColor] {
        return colors
    }
    
}
