
import UIKit

final class BaseColorsProvider: ColorsProvider {
    
    let colors: [UIColor] = [
        .systemBlue
    ]
    
    func getColors() -> [UIColor] {
        return colors
    }
    
}
