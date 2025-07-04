
import UIKit

struct IconPickerCollectionConfiguration: UIContentConfiguration {
    
    var color: UIColor = .black
    var image: UIImage = UIImage()
    var isHighlited = false
    
    func makeContentView() -> any UIView & UIContentView {
        return IconPickerCollectionContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> IconPickerCollectionConfiguration {
        if let state = state as? UICellConfigurationState {
            return IconPickerCollectionConfiguration(color: self.color, image: self.image, isHighlited: state.isHighlighted || state.isSelected)
        }
        return self
    }
    
}
