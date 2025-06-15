
import UIKit

final class UIColorProvider: ColorProvider {
    
    private let colors: [UIColor] = [
        .systemBlue
    ]
    
    
    func getColors() -> [UIColor] {
        return colors
    }
    
}
