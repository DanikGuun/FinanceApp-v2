
import UIKit

protocol TransactionCategoryIcon{
    
    var image: UIImage { get }
    var kind: TransactionCategory { get }
    
}

enum TransactionCategoryIconKind{
    case base
}
