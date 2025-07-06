
import UIKit

struct TransactionListConfiguration: UIContentConfiguration {
    
    var id: UUID = UUID()
    var title = ""
    var subtitle = ""
    var image: UIImage? = nil
    var color: UIColor = .systemBlue
    var isHighlighted = false
    
    func makeContentView() -> any UIView & UIContentView {
        return TransactionListContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> TransactionListConfiguration {
        if let state = state as? UICellConfigurationState {
            return TransactionListConfiguration(id: id, title: title, subtitle: subtitle, image: image, color: color, isHighlighted: state.isSelected || state.isHighlighted)
        }
        return self
    }
    
    
}
