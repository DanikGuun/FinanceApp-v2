
import UIKit

struct ImageAndTitleCollectionConfiguration: UIContentConfiguration {
    
    var item: ImageAndTitleItem?
    var isSelected: Bool = false
    var isHighlighted: Bool = false
    
    func makeContentView() -> any UIView & UIContentView {
        return ImageAndTitleCollectionContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> ImageAndTitleCollectionConfiguration {
        if let state = state as? UICellConfigurationState {
            let conf = ImageAndTitleCollectionConfiguration(item: self.item, isSelected: state.isSelected, isHighlighted: state.isHighlighted)
            return conf
        }
        return self
    }
    
    
}
