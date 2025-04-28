
import UIKit
import Foundation

struct CategoriesSummaryChartCellConfiguration: UIContentConfiguration {

    var elements: [CategoriesSummaryItem] = []
    var interval: DateInterval = DateInterval()
    var chartDidPressed: (([CategoriesSummaryItem]) -> Void)?
    var intervalButtonDidPressed: ((DateInterval) -> Void)?
    
    func makeContentView() -> any UIView & UIContentView {
        return  CategoriesSummaryChartContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> CategoriesSummaryChartCellConfiguration {
        return self
    }
    
    
    
}
