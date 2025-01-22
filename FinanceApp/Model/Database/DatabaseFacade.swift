
import Foundation
import UIKit

protocol DatabaseFacade: TransactionDatabase, CategoryDatabase, IconProvider, ColorsProvider{
    
    init(transactionsDB: TransactionDatabase, categoryDB: CategoryDatabase, iconProviders: [IconProvider], colorProviders: [ColorsProvider])
    
    func totalAmount(_ type: CategoryType, for interval: DateInterval?) -> Double
    func categoriesSummary(_ type: CategoryType, for interval: DateInterval?) -> [TransactionCategoryMeta]
    
}

struct TransactionCategoryMeta: IdentifiableCategory {
    
    //Protocol
    var id: UUID { get { category.id } set { } }
    var name: String { get { category.name } set { } }
    var type: CategoryType { get { category.type } set { } }
    var iconID: String { get { category.iconID } set { } }
    var color: UIColor { get { category.color } set { } }
    //
    
    let category: any IdentifiableCategory
    let amount: Double
    let percentage: Double
    
    init(category: any IdentifiableCategory, amount: Double, percentage: Double) {
        self.category = category
        self.amount = amount
        self.percentage = percentage
    }
    
}
