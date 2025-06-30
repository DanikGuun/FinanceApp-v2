
import UIKit

struct IconPickerCollectionConfiguration: UIContentConfiguration {
    
    var color: UIColor = .black
    var image: UIImage = UIImage()
    
    func makeContentView() -> any UIView & UIContentView {
        return IconPickerCollectionContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> IconPickerCollectionConfiguration {
        return self
    }
    
    
}
