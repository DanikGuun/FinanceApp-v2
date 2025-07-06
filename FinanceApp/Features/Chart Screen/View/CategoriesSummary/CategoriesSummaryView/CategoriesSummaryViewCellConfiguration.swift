
import UIKit

struct CategoriesSummaryViewCellConfiguration: UIContentConfiguration {
    
    var element: CategoriesSummaryItem = CategoriesSummaryItem()
    var percentage: Int = 0
    var isSelected: Bool = false
    
    func makeContentView() -> any UIView & UIContentView {
        return CategoriesSummaryViewCellContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> CategoriesSummaryViewCellConfiguration {
        if let state = state as? UICellConfigurationState {
            return CategoriesSummaryViewCellConfiguration(element: element, percentage: percentage, isSelected: state.isSelected || state.isHighlighted)
        }
        return self
    }
    
    
}
