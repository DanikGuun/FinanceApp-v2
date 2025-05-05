
import Foundation
import UIKit


protocol CategoriesSummaryPresenter: UIView {
    
    var delegate: CategoriesSummaryDelegate? { get set }
    var dataSource: CategoriesSummaryDataSource? { get set }
    
    var interval: DateInterval { get set }
    var intervalType: IntervalType { get set }
    
    func reloadData()
    
}

protocol CategoriesSummaryDelegate {
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter, openSummaryControllerFor interval: DateInterval, category: CategoriesSummaryItem?)
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter, requestToOpenIntervalPicker type: IntervalType)
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter, didSelectInterval interval: DateInterval)
}

extension CategoriesSummaryDelegate {
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter,  openSummaryControllerFor interval: DateInterval, category: CategoriesSummaryItem?) {}
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter, requestToOpenIntervalPicker type: IntervalType) {}
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter, didSelectInterval interval: DateInterval) {}
}

protocol CategoriesSummaryDataSource {
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter, getSummaryItemsFor interval: DateInterval) -> [CategoriesSummaryItem]
}

struct CategoriesSummaryItem: Equatable, Identifiable {
    
    var id = UUID()
    var amount: Double
    var color: UIColor
    var title: String
    var image: UIImage?
    
    init(id: UUID = UUID(), amount: Double = 0.0, color: UIColor = .black, title: String = "", image: UIImage? = UIImage()){
        self.id = id
        self.amount = amount
        self.color = color
        self.title = title
        self.image = image
    }
    
}
