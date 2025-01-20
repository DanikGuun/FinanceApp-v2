
import UIKit

protocol TransactionCategoryIcon{
    
    var image: UIImage { get }
    var kind: TransactionCategoryIconKind { get }
    
}

enum TransactionCategoryIconKind{
    case base
}
