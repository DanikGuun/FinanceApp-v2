
import Foundation
import UIKit

protocol ChartModel {
    func getCategoriesSummary(type: CategoryType, interval: DateInterval?) -> [TransactionCategoryMeta]
    func getIcon(iconId: String) -> UIImage?
}

public final class BaseChartModel: ChartModel {
    
    let database: DatabaseFacade
    
    init(database: DatabaseFacade) {
        self.database = database
    }
    
    func getCategoriesSummary(type: CategoryType, interval: DateInterval?) -> [TransactionCategoryMeta] {
        let items = database.categoriesSummary(type, for: interval)
        return items.filter { $0.amount > 0 }
    }
    
    func getIcon(iconId: String) -> UIImage? {
        database.getIcon(id: iconId)?.image
    }
}
