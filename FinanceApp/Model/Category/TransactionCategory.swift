import UIKit

protocol TransactionCategory {
    var name: String { get set }
    var type: TransactionType { get set }
    var icon: String { get set }
    var color: UIColor { get set }
}
