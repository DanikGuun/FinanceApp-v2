
import Foundation
import UIKit

protocol TransactionListModel {
    func getTransactionList(for dateIntrval: DateInterval, category: any IdentifiableCategory) -> [TransactionListItem]
    func getTransactionList(for dateIntrval: DateInterval, type: CategoryType) -> [TransactionListItem]
    func getIcon(iconId: String) -> UIImage?
}

public class BaseTransactionListModel: TransactionListModel {
    var database: DatabaseFacade
    
    init(database: DatabaseFacade) {
        self.database = database
    }
    
    func getTransactionList(for dateIntrval: DateInterval, category: any IdentifiableCategory) -> [TransactionListItem] {
        let transactions = database.getTransactions(interval: dateIntrval, category: category)
        let items = sortTransactionsByIntervals(transactions: transactions)
        return items
    }
    
    func getTransactionList(for dateIntrval: DateInterval, type: CategoryType) -> [TransactionListItem] {
        let categories = database.getCategories(of: type)
        let transactions = categories.reduce([], { $0 + database.getTransactions(interval: dateIntrval, category: $1) }) //собираем транзакции со всех категорий типа
        let items = sortTransactionsByIntervals(transactions: transactions)
        return items
    }
    
    private func sortTransactionsByIntervals(transactions: [any IdentifiableTransaction]) -> [TransactionListItem] {
        var transactionsByDate: [DateInterval: [any Transaction]] = [:]
        
        for transaction in transactions {
            let dayInterval = Calendar.current.dateInterval(of: .day, for: transaction.date) ?? DateInterval()
            transactionsByDate[dayInterval, default: []].append(transaction)
        }
        
        let items = transactionsByDate.keys.map { key in TransactionListItem(interval: key, items: transactionsByDate[key] ?? []) }
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
    var items: [any Transaction]
    
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
