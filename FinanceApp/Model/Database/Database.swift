
import Foundation
import UIKit

class Database: DatabaseFacade{
    
    //DB
    private var transactionsDB: TransactionDatabase
    private var categoriesDB: CategoryDatabase
    private var iconProviders: [IconProvider]
    private var colorProviders: [ColorsProvider]
    //
    var offset: Double {
        get { return transactionsDB.offset }
        set { transactionsDB.offset = newValue }
    }
    
    required init(transactionsDB: any TransactionDatabase, categoryDB: any CategoryDatabase, iconProviders: [any IconProvider], colorProviders: [any ColorsProvider]) {
        self.transactionsDB = transactionsDB
        self.categoriesDB = categoryDB
        self.iconProviders = iconProviders
        self.colorProviders = colorProviders
    }
    
    //MARK: - Transactions
    func transaction(id: UUID) -> (any IdentifiableTransaction)? {
        return transactionsDB.transaction(id: id)
    }
    
    func allTransactions(period: DateInterval?) -> [any IdentifiableTransaction] {
        return transactionsDB.allTransactions(period: period)
    }
    
    func transactions(period: DateInterval?, category: any IdentifiableCategory) -> [any IdentifiableTransaction] {
        return transactionsDB.transactions(period: period, category: category)
    }
    
    @discardableResult func add(_ transaction: any Transaction) -> (any IdentifiableTransaction)? {
        return transactionsDB.add(transaction)
    }
    
    func update(_ transaction: any IdentifiableTransaction, with newTransaction: any Transaction) {
        transactionsDB.update(transaction, with: newTransaction)
    }
    
    func remove(_ transaction: any IdentifiableTransaction) {
        transactionsDB.remove(transaction)
    }
    
    //MARK: - Categories
    func category(id: UUID) -> (any IdentifiableCategory)? {
        return categoriesDB.category(id: id)
    }
    
    func allCategories() -> [any IdentifiableCategory] {
        return categoriesDB.allCategories()
    }
    
    func categories(of type: CategoryType) -> [any IdentifiableCategory] {
        return categoriesDB.categories(of: type)
    }
    
    @discardableResult func add(_ category: any Category) -> (any IdentifiableCategory)? {
        return categoriesDB.add(category)
    }
    
    func update(_ category: any IdentifiableCategory, with newCategory: any Category) {
        categoriesDB.update(category, with: newCategory)
    }
    
    func remove(_ category: any IdentifiableCategory) {
        categoriesDB.remove(category)
    }
    
    func totalAmount(_ type: CategoryType, for interval: DateInterval? = nil) -> Double {
        
        let categories = categoriesDB.categories(of: type)
        var totalAmount: Double = 0
        
        for category in categories {
            let transactions = transactionsDB.transactions(period: interval, category: category)
            totalAmount += transactions.reduce(0, { $0 + $1.amount })
        }
        
        return totalAmount
    }
    
    func categoriesSummary(_ type: CategoryType, for interval: DateInterval? = nil) -> [TransactionCategoryMeta] {
        
        let categories = categoriesDB.categories(of: type)
        let totalAmount = totalAmount(type, for: interval)
        
        var meta: [TransactionCategoryMeta] = []
        
        for category in categories {
            
            let transactions = transactions(period: interval, category: category)
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
