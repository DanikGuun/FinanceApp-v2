
import UIKit

struct CategoriesSummaryViewCellConfiguration: UIContentConfiguration {
    
    var element: CategoriesSummaryItem = CategoriesSummaryItem()
    var percentage: Int = 0
    var categoryDidPressed: ((CategoriesSummaryItem) -> Void)?
    
    func makeContentView() -> any UIView & UIContentView {
        return CategoriesSummaryViewCellContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> CategoriesSummaryViewCellConfiguration {
        return self
    }
    
    
}
