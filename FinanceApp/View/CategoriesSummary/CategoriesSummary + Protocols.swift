
import Foundation
import UIKit


protocol CategoriesSummaryPresenter: UIView {
    
    var delegate: CategoriesSummaryDelegate? { get set }
    var dataSource: CategoriesSummaryDataSource? { get set }
    
    func reloadData()
    
}

protocol CategoriesSummaryDelegate {
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter,  openSummaryControllerFor interval: DateInterval, category: CategoriesSummaryItem?)
}

extension CategoriesSummaryDelegate {
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter,  openSummaryControllerFor interval: DateInterval, category: CategoriesSummaryItem?) {}
}

protocol CategoriesSummaryDataSource {
    func categoriesSummary(_ presenter: CategoriesSummaryPresenter, getSummaryItemsFor interval: DateInterval) -> [CategoriesSummaryItem]
}

struct CategoriesSummaryItem: Equatable, Identifiable {
    
    let id = UUID()
    var amount: Double
    var color: UIColor
    
    init(){
        self.init(amount: 0, color: .systemGray6)
    }
    
    init(amount: Double, color: UIColor){
        self.amount = amount
        self.color = color
    }
    
}
