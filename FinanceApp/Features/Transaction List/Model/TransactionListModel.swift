
import Foundation
import UIKit

protocol TransactionListModel {
    func getTransactionList(for dateIntrval: DateInterval, category: any IdentifiableCategory) -> [TransactionListItem]
    func getTransactionList(for dateIntrval: DateInterval, type: CategoryType) -> [TransactionListItem]
    func getTransactionWithLastConfiguration() -> [TransactionListItem]
    func getIcon(iconId: String) -> UIImage?
    func getCategory(id: UUID) -> (any Category)?
}

public class BaseTransactionListModel: TransactionListModel {
    var database: DatabaseFacade
    var dateInterval = DateInterval()
    var lastCategory: (any IdentifiableCategory)?
    var lastType: CategoryType?
    
    init(database: DatabaseFacade) {
        self.database = database
    }
    
    func getTransactionList(for dateIntrval: DateInterval, category: any IdentifiableCategory) -> [TransactionListItem] {
        let transactions = database.getTransactions(interval: dateIntrval, categoryId: category.id)
        let items = sortTransactionsByIntervals(transactions: transactions)
        return items
    }
    
    func getTransactionList(for dateIntrval: DateInterval, type: CategoryType) -> [TransactionListItem] {
        let categories = database.getCategories(of: type)
        let transactions = categories.reduce([], { $0 + database.getTransactions(interval: dateIntrval, categoryId: $1.id) }) //собираем транзакции со всех категорий типа
        let items = sortTransactionsByIntervals(transactions: transactions)
        return items
    }
    
    func getTransactionWithLastConfiguration() -> [TransactionListItem] {
        if let lastCategory {
            return getTransactionList(for: dateInterval, category: lastCategory)
        }
        if let lastType {
            return getTransactionList(for: dateInterval, type: lastType)
        }
        return []
    }
    
    private func sortTransactionsByIntervals(transactions: [any IdentifiableTransaction]) -> [TransactionListItem] {
        var transactionsByDate: [DateInterval: [any IdentifiableTransaction]] = [:]
        
        for transaction in transactions {
            let dayInterval = Calendar.current.dateInterval(of: .day, for: transaction.date) ?? DateInterval()
            transactionsByDate[dayInterval, default: []].append(transaction)
        }
        
        let items = transactionsByDate.keys.map { key in TransactionListItem( interval: key, items: transactionsByDate[key] ?? []) }
        return items.sorted { $0.interval.start > $1.interval.start }
    }
    
    func getCategory(id: UUID) -> (any Category)? {
        return database.getCategory(id: id)
    }
    
    func getIcon(iconId: String) -> UIImage? {
        return database.getIcon(id: iconId)?.image
    }
    
}

public struct TransactionListItem: Identifiable, Equatable {
    public var id = UUID()
    var interval = DateInterval()
    var items: [any IdentifiableTransaction]
    
    public static func ==(lhs: TransactionListItem, rhs: TransactionListItem) -> Bool {
        return lhs.interval == rhs.interval && isTransactionItemsEqual(lhs.items, rhs.items)
    }
    
    private static func isTransactionItemsEqual(_ lhs: [any Transaction], _ rhs: [any Transaction]) -> Bool {
        guard lhs.count == rhs.count else { return false }
        
        for i in 0..<lhs.count {
            if !(
                lhs[i].categoryID == rhs[i].categoryID &&
                lhs[i].amount == rhs[i].amount &&
                lhs[i].date == rhs[i].date &&
                lhs[i].information == rhs[i].information
            ) {
                return false
            }
        }
                
        return true
    }
}
