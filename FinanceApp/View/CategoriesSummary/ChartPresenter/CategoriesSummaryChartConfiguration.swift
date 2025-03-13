
import UIKit
import Foundation

struct CategoriesSummaryChartConfiguration: UIContentConfiguration {

    var elements: [CategoriesSummaryItem] = []
    var interval: DateInterval = DateInterval()
    var chartDidPressed: (() -> Void)?
    var intervalButtonDidPressed: (() -> Void)?
    
    func makeContentView() -> any UIView & UIContentView {
        return  CategoriesSummaryChartContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> CategoriesSummaryChartConfiguration {
        return self
    }
    
    
    
}
