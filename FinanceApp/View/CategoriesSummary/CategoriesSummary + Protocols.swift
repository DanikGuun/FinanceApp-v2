
import Foundation
import UIKit


protocol CategoriesSummaryPresenter {
    
    var delegate: CategoriesSummaryDelegate? { get set }
    var dataSource: CategoriesSummaryDataSource? { get set }
    
    func reloadData()
    
}

protocol CategoriesSummaryDelegate {
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter,  openSummaryControllerFor interval: DateInterval, category: CategoriesSummaryItem)
}

extension CategoriesSummaryDelegate {
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter,  openSummaryControllerFor interval: DateInterval, category: CategoriesSummaryItem) {}
}

protocol CategoriesSummaryDataSource {
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter, getTransactionFor interval: DateInterval) -> [CategoriesSummaryItem]
}

struct CategoriesSummaryItem {
    
    var amount: Double
    var color: UIColor
    
}

enum IntervalType: Equatable {
    
    case day
    case week
    case month
    case year
    case custom(interval: DateInterval)
    
    func calendarComponent() -> Calendar.Component? {
        switch self {
        case .day:
            return .day
        case .week:
            return .weekOfYear
        case .month:
            return .month
        case .year:
            return .year
        case .custom:
            return nil
        }
    }
    
}
