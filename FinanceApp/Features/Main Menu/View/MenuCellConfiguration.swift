
import UIKit

struct MenuCellConfiguration: UIContentConfiguration {
    
    var title = ""
    var image: UIImage? = nil
    var isSelected = false
    
    func makeContentView() -> any UIView & UIContentView {
        return MenuCellContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> MenuCellConfiguration {
        if let state = state as? UICellConfigurationState {
            return MenuCellConfiguration(title: title, image: image, isSelected: state.isSelected || state.isHighlighted)
        }
        return self
    }
    
    
}
