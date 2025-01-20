
import UIKit

final class BaseColorProvider: TransactionCategoryColorsProvider {
    
    let colors: [UIColor] = [
        .systemBlue
    ]
    
    func getColors() -> [UIColor] {
        return colors
    }
    
}
