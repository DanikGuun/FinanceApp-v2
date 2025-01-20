
import UIKit

protocol TransactionCategoryIcon{
    
    var image: UIImage { get }
    var kind: any TransactionCategory { get }
    
}

enum TransactionCategoryIconKind{
    case base
}
