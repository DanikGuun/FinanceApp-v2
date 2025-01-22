
import Foundation
import UIKit

protocol DatabaseFacade: TransactionDatabase, TransactionCategoryDatabase, TransactionCategoryIconProvider, TransactionCategoryColorsProvider{
    
    init(transactionsDB: TransactionDatabase, categoryDB: TransactionCategoryDatabase, iconProviders: [TransactionCategoryIconProvider], colorProviders: [TransactionCategoryColorsProvider])
    
    func totalAmount(_ type: TransactionType, for interval: DateInterval?) -> Double
    func categoriesSummary(_ type: TransactionType, for interval: DateInterval?) -> [TransactionCategoryMeta]
    
}

struct TransactionCategoryMeta: IdentifiableTransactionCategory {
    
    //Protocol
    var id: UUID { get { category.id } set { } }
    var name: String { get { category.name } set { } }
    var type: TransactionType { get { category.type } set { } }
    var iconID: String { get { category.iconID } set { } }
    var color: UIColor { get { category.color } set { } }
    //
    
    let category: any IdentifiableTransactionCategory
    let amount: Double
    let percentage: Double
    
    init(category: any IdentifiableTransactionCategory, amount: Double, percentage: Double) {
        self.category = category
        self.amount = amount
        self.percentage = percentage
    }
    
}
