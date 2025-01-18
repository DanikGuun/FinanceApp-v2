
import UIKit

protocol CategoryIcon{
    
    var image: UIImage { get }
    var kind: CategoryIconKind { get }
    
}

enum CategoryIconKind{
    case base
}
