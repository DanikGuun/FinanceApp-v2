
import Foundation
import UIKit

class Database: DatabaseFacade{
    
    //DB
    private var transactionsDB: TransactionDatabase
    private var categoriesDB: CategoryDatabase
    private var iconProviders: [IconProvider]
    private var colorProviders: [ColorsProvider]
    //
    var moneyOffset: Double {
        get { return transactionsDB.moneyOffset }
        set { transactionsDB.moneyOffset = newValue }
    }
    
    required init(transactionsDB: any TransactionDatabase, categoryDB: any CategoryDatabase, iconProviders: [any IconProvider], colorProviders: [any ColorsProvider]) {
        self.transactionsDB = transactionsDB
        self.categoriesDB = categoryDB
        self.iconProviders = iconProviders
        self.colorProviders = colorProviders
    }
    
    //MARK: - Transactions
    func getTransaction(id: UUID) -> (any IdentifiableTransaction)? {
        return transactionsDB.getTransaction(id: id)
    }
    
    func getAllTransactions(interval: DateInterval?) -> [any IdentifiableTransaction] {
        return transactionsDB.getAllTransactions(interval: interval)
    }
    
    func getTransactions(interval: DateInterval?, category: any IdentifiableCategory) -> [any IdentifiableTransaction] {
        return transactionsDB.getTransactions(interval: interval, category: category)
    }
    
    @discardableResult func addTransaction(_ transaction: any Transaction) -> (any IdentifiableTransaction)? {
        return transactionsDB.addTransaction(transaction)
    }
    
    func updateTransaction(id: UUID, with newTransaction: any Transaction) {
        transactionsDB.updateTransaction(id: id, with: newTransaction)
    }
    
    func removeTransaction(_ transaction: any IdentifiableTransaction) {
        transactionsDB.removeTransaction(transaction)
    }
    
    //MARK: - Categories
    func getCategory(id: UUID) -> (any IdentifiableCategory)? {
        return categoriesDB.getCategory(id: id)
    }
    
    func getAllCategories() -> [any IdentifiableCategory] {
        return categoriesDB.getAllCategories()
    }
    
    func getCategories(of type: CategoryType) -> [any IdentifiableCategory] {
        return categoriesDB.getCategories(of: type)
    }
    
    @discardableResult func addCategory(_ category: any Category) -> (any IdentifiableCategory)? {
        return categoriesDB.addCategory(category)
    }
    
    func updateCategory(id: UUID, with newCategory: any Category) {
        categoriesDB.updateCategory(id: id, with: newCategory)
    }
    
    func removeCategory(_ category: any IdentifiableCategory) {
        categoriesDB.removeCategory(category)
    }
    
    func totalAmount(_ type: CategoryType, for interval: DateInterval? = nil) -> Double {
        
        let categories = categoriesDB.getCategories(of: type)
        var totalAmount: Double = 0
        
        for category in categories {
            let transactions = transactionsDB.getTransactions(interval: interval, category: category)
            totalAmount += transactions.reduce(0, { $0 + $1.amount })
        }
        
        return totalAmount
    }
    
    func categoriesSummary(_ type: CategoryType, for interval: DateInterval? = nil) -> [TransactionCategoryMeta] {
        
        let categories = categoriesDB.getCategories(of: type)
        let totalAmount = totalAmount(type, for: interval)
        
        var meta: [TransactionCategoryMeta] = []
        
        for category in categories {
            let transactions = getTransactions(interval: interval, category: category)
            let amount = transactions.reduce(0, { $0 + $1.amount } )
            let newMeta = TransactionCategoryMeta(category: category, amount: amount, percentage: amount/totalAmount*100)
            meta.append(newMeta)
        }
        
        return meta
        
    }
    
    //MARK: - Icons
    func getIcons() -> [any Icon] {
        return iconProviders.reduce([], { $0 + $1.getIcons() }) //Собираем иконки со всех провайдеров
    }
    
    func getIcon(id: String) -> (any Icon)? {
        
        for provider in iconProviders {
            if let icon = provider.getIcon(id: id) { return icon }
        }
        return nil
        
    }
    
    func getIconsWithKind() -> [IconKind : [any Icon]] {
        
        var dict: [IconKind : [any Icon]] = [:]
        
        for provider in iconProviders {
            let currentDictionary = provider.getIconsWithKind()
            dict.merge(currentDictionary) { (first, second) in first + second }
        }
        
        return dict
        
    }
    
    //MARK: - Colors
    func getColors() -> [UIColor] {
        return colorProviders.reduce([], { $0 + $1.getColors() } )
    }
    
    
}
