
import Foundation
import UIKit

protocol TransactionCategoryIcon{
    
    var id: String { get }
    var image: UIImage { get }
    var kind: TransactionCategoryIconKind { get }
    
}

enum TransactionCategoryIconKind{
    case base
}
