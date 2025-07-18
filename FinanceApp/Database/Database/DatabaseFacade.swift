
import Foundation
import UIKit

protocol DatabaseFacade: TransactionDatabase, CategoryDatabase, IconProvider, ColorProvider{
    
    func totalAmount(_ type: CategoryType, for interval: DateInterval?) -> Double
    func categoriesSummary(_ type: CategoryType, for interval: DateInterval?) -> [TransactionCategoryMeta]
    
}

struct TransactionCategoryMeta: IdentifiableCategory {
    
    //Protocol
    var id: UUID { get { category.id } set { } }
    var name: String { get { category.name } set { } }
    var type: CategoryType { get { category.type } set { } }
    var iconId: String { get { category.iconId } set { } }
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
    
    static func == (lhs: TransactionCategoryMeta, rhs: TransactionCategoryMeta) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.type == rhs.type && lhs.iconId == rhs.iconId && lhs.color == rhs.color && lhs.amount == rhs.amount && lhs.percentage == rhs.percentage
    }
    
}
