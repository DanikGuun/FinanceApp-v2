
import UIKit

class CompositeColorProvider: ColorProvider {
    
    var colorProviders: [ColorProvider]
    
    init(colorProviders: [ColorProvider]) {
        self.colorProviders = colorProviders
    }
    
    static func getInstance() -> CompositeColorProvider {
        return CompositeColorProvider(colorProviders: [UIColorProvider()])
    }
    
    func getColors() -> [UIColor] {
        return colorProviders.reduce([], { $0 + $1.getColors() })
    }
    
    
}
