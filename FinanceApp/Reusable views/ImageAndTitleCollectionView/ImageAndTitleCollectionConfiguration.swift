
import UIKit

struct ImageAndTitleCollectionConfiguration: UIContentConfiguration {
    
    var item: ImageAndTitleItem?
    
    func makeContentView() -> any UIView & UIContentView {
        return ImageAndTitleCollectionContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> ImageAndTitleCollectionConfiguration {
        return self
    }
    
    
}
