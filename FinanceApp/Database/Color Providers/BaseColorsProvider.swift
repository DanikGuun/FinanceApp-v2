
import UIKit

final class BaseColorsProvider: ColorsProvider {
    
    private let colors: [UIColor] = [
        .systemBlue
    ]
    
    
    func getColors() -> [UIColor] {
        return colors
    }
    
}
