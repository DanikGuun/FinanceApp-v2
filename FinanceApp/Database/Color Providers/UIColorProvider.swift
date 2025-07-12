
import UIKit

final class UIColorProvider: ColorProvider {
    
    private let colors: [UIColor] = [
        .systemBlue,
        .systemRed,
        .systemGreen,
        .systemOrange
    ]
    
    
    func getColors() -> [UIColor] {
        return colors
    }
    
}
